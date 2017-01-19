//
//  VTAddCardController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTAddCardController.h"
#import "VTClassHelper.h"
#import "MidtransUITextField.h"
#import "VTCvvInfoController.h"
#import "MidtransUICCFrontView.h"
#import "VTCCBackView.h"
#import "MidtransUICardFormatter.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "IHKeyboardAvoiding_vt.h"
#import "UIViewController+Modal.h"
#import "MidtransUIThemeManager.h"
#import "VTCCBackView.h"
#import "VTAddCardView.h"
#import "MidtransLoadingView.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransPaymentRequestV2DataModels.h>
#import <MidtransCoreKit/MidtransBinResponse.h>
#import <MidtransCoreKit/MidtransPaymentRequestV2Installment.h>
#import "MidtransUIConfiguration.h"
#import "MidtransUICardFormatter.h"
#import "MidtransInstallmentView.h"
static const NSInteger installmentHeight = 50;
#if __has_include(<CardIO/CardIO.h>)
#import <CardIO/CardIO.h>
@interface VTAddCardController () <CardIOPaymentViewControllerDelegate,UITextFieldDelegate,MidtransUICardFormatterDelegate>
#else
@interface VTAddCardController () <UITextFieldDelegate,MidtransUICardFormatterDelegate,MidtransInstallmentViewDelegate>
#endif

@property (strong, nonatomic) IBOutlet VTAddCardView *view;
@property (nonatomic) MidtransUICardFormatter *ccFormatter;
@property (nonatomic) BOOL saveCard;
@property (nonatomic,strong)MidtransInstallmentView *installmentsContentView;
@property (strong, nonatomic) IBOutlet UIView *didYouKnowView;
@property (nonatomic) NSMutableArray *maskedCards;
@property (nonatomic,strong)NSMutableArray *installmentValueObject;
@property (nonatomic) NSArray *bins;
@property (nonatomic,strong) NSString *installmentTerms;
@property (nonatomic,strong) MidtransPaymentRequestV2Installment *installment;
@property (nonatomic,strong) NSArray *binResponseObject;
@property (nonatomic,strong) MidtransBinResponse *filteredBinObject;
@property (nonatomic) BOOL installmentAvailable,installmentRequired;
@property (nonatomic,strong) MidtransPaymentListModel *paymentMethodInfo;
@property (nonatomic,strong) NSString *installmentBankName;
@property (nonatomic,strong) MidtransPaymentRequestV2CreditCard *creditCardInfo;
@property (nonatomic) NSInteger attemptRetry;
@property (nonatomic)NSInteger installmentCurrentIndex;

@end

@implementation VTAddCardController

@dynamic view;
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token paymentMethodName:(MidtransPaymentListModel *)paymentMethod andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard {
    if (self = [super initWithToken:token]) {
        self.creditCardInfo = creditCard;
        self.paymentMethodInfo = paymentMethod;
    }
    return self;
}
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token maskedCards:(NSMutableArray *)maskedCards bins:(NSArray *)bins {
    if (self = [super initWithToken:token]) {
        self.maskedCards = maskedCards;
        self.bins = bins;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.maskedCards) {
        self.maskedCards = [NSMutableArray new];
    }
    
    self.installmentValueObject = [NSMutableArray new];
    self.attemptRetry = 0;

    self.view.installmentWrapperViewConstraints.constant = 0;
    self.installmentCurrentIndex = 0;
    self.installmentBankName = @"";
    self.view.cardNumber.delegate = self;
    self.view.cardExpiryDate.delegate = self;
    self.view.cardCvv.delegate = self;
    self.ccFormatter = [[MidtransUICardFormatter alloc] initWithTextField:self.view.cardNumber];
    self.ccFormatter.delegate = self;
    self.ccFormatter.numberLimit = 16;

    self.didYouKnowView.layer.cornerRadius = 3.0f;
    self.didYouKnowView.layer.borderWidth = 1.0f;
    self.didYouKnowView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.title = UILocalizedString(@"creditcard.input.title", nil);
    
    [self addNavigationToTextFields:@[self.view.cardNumber, self.view.cardExpiryDate, self.view.cardCvv]];
    
    if ([CC_CONFIG paymentType] == MTCreditCardPaymentTypeNormal) {
        self.view.saveCardView.hidden = YES;

        self.view.saveCardViewHeight.constant = 0;
        [self.view updateConstraintsIfNeeded];
    }
    else {
        if ([CC_CONFIG setDefaultCreditSaveCardEnabled]) {
            self.view.saveCardSwitch.selected = YES;
        }
        self.view.saveCardView.hidden = NO;
        self.view.saveCardViewHeight.constant = 70;
    }
    [self.view setToken:self.token];
    self.bins = self.creditCardInfo.whitelistBins;
    self.installmentAvailable = NO;
    self.installment =[[MidtransPaymentRequestV2Installment alloc] initWithDictionary: [[self.creditCardInfo dictionaryRepresentation] valueForKey:@"installment"]];

    if (self.installment.terms) {
        self.installmentAvailable = YES;
        self.installmentRequired = self.installment.required;
                [[MidtransClient shared] requestCardBINForInstallmentWithCompletion:^(NSArray *binResponse, NSError * _Nullable error) {
                    if (!error) {
                        self.binResponseObject = binResponse;
                         [self setupInstallmentView];
                    }
                }];

    }
#if __has_include(<CardIO/CardIO.h>)
    [self.view hideScanCardButton:NO];
    //speedup cardio launch
    [CardIOUtilities preloadCardIO];
#else
    [self.view hideScanCardButton:YES];
#endif
    
    self.didYouKnowView.hidden = UICONFIG.hideDidYouKnowView;
}
- (void)setupInstallmentView {
    NSArray *subviewArray = [VTBundle loadNibNamed:@"MidtransInstallmentView" owner:self options:nil];
    self.installmentsContentView = [subviewArray objectAtIndex:0];
    self.installmentsContentView.delegate = self;
    [self.view.installmentView  addSubview:self.installmentsContentView];
    [self.installmentsContentView setupInstallmentCollection];

}
- (IBAction)cvvInfoPressed:(UIButton *)sender {
    VTCvvInfoController *guide = [[VTCvvInfoController alloc] init];
    [self.navigationController presentCustomViewController:guide onViewController:self.navigationController completion:nil];
}
- (IBAction)saveCardButtonDidtapped:(id)sender {
    self.view.saveCardSwitch.selected =!self.view.saveCardSwitch.selected;
}

- (IBAction)registerPressed:(UIButton *)sender {
    if (self.installmentAvailable && self.installmentCurrentIndex!=0) {

        self.installmentTerms = [NSString stringWithFormat:@"%@_%@",self.installmentBankName, [[self.installment.terms  objectForKey:self.installmentBankName] objectAtIndex:self.installmentCurrentIndex -1]];
    }
    
    if (self.installmentRequired && self.installmentCurrentIndex==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"This transaction must use installment"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    MidtransCreditCard *creditCard = [[MidtransCreditCard alloc] initWithNumber:self.view.cardNumber.text
                                                                     expiryDate:self.view.cardExpiryDate.text
                                                                            cvv:self.view.cardCvv.text];
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        [self handleRegisterCreditCardError:error];
        return;
    }
    if (self.bins.count) {
        if ([MidtransClient isCard:creditCard eligibleForBins:self.bins error:&error] == NO) {
            [self handleRegisterCreditCardError:error];
            return;
        }
        
    }

    [self showLoadingWithText:@"Processing your transaction"];
    
    MidtransTokenizeRequest *tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                                    grossAmount:self.token.transactionDetails.grossAmount
                                                                                         secure:CC_CONFIG.secure3DEnabled];
    
    [[MidtransClient shared] generateToken:tokenRequest
                                completion:^(NSString * _Nullable token, NSError * _Nullable error) {
                                    if (error) {
                                        [self hideLoading];
                                        [self handleTransactionError:error];
                                    } else {
                                        [self payWithToken:token];
                                    }
                                }];
}

- (void)handleRegisterCreditCardError:(NSError *)error {
    if ([self.view isViewableError:error] == NO) {
        [self showAlertViewWithTitle:@"Error"
                          andMessage:error.localizedDescription
                      andButtonTitle:@"Close"];
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard modelWithToken:token
                                                                                customer:self.token.customerDetails
                                                                                saveCard:self.view.saveCardSwitch.selected
                                                                             installment:self.installmentTerms];
    NSLog(@"payment detail->%@",[paymentDetail dictionaryValue]);
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        
        if (error) {
            if (self.attemptRetry < 2) {
                self.attemptRetry+=1;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                [self handleTransactionError:error];
            }
        }
        else {
            if (![CC_CONFIG tokenStorageEnabled] && result.maskedCreditCard) {
                [self.maskedCards addObject:result.maskedCreditCard];
                [[MidtransMerchantClient shared] saveMaskedCards:self.maskedCards customer:self.token.customerDetails completion:^(id  _Nullable result, NSError * _Nullable error) {
                    
                }];
            }
            if ([[result.additionalData objectForKey:@"fraud_status"] isEqualToString:@"challenge"]) {
                [self handleTransactionResult:result];
            }
            else {
                 if ([result.transactionStatus isEqualToString:MIDTRANS_TRANSACTION_STATUS_DENY] && self.attemptRetry<2) {
                    self.attemptRetry+=1;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                    message:result.statusMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    [self handleTransactionSuccess:result];
                }
            }
        }
    }];
}

#if __has_include(<CardIO/CardIO.h>)

- (IBAction)scanCardDidTapped:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.collectCVV = NO;
    scanViewController.collectExpiry = NO;
    scanViewController.hideCardIOLogo = YES;
    [self.navigationController presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.view.cardNumber.text = cardInfo.cardNumber;
    [self.view reformatCardNumber];
    
    self.view.cardCvv.text = cardInfo.cvv;
    
    self.view.cardExpiryDate.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)cardInfo.expiryMonth, (unsigned long)cardInfo.expiryYear];
}
- (void)reformatCardNumber {
    NSString *cardNumber = self.view.cardNumber.text;
    NSString *formatted = [NSString stringWithFormat: @"%@ %@ %@ %@",
                           [cardNumber substringWithRange:NSMakeRange(0,4)],
                           [cardNumber substringWithRange:NSMakeRange(4,4)],
                           [cardNumber substringWithRange:NSMakeRange(8,4)],
                           [cardNumber substringWithRange:NSMakeRange(12,4)]];
    
    self.view.cardNumber.text = formatted;
    self.view.cardNumber.infoIcon = [self iconDarkWithNumber:self.view.cardNumber.text];
    
    self.view.cardFrontView.iconView.image = [self iconWithNumber:self.view.cardNumber.text];
    self.view.cardFrontView.numberLabel.text = formatted;
}

#endif

- (void)dealloc {
    if ([self.view.cardExpiryDate observationInfo]!=nil) {
        [self.view.cardExpiryDate removeObserver:self forKeyPath:@"text"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    if ([self.view.cardExpiryDate observationInfo]!=nil) {
        [self.view.cardExpiryDate removeObserver:self forKeyPath:@"text"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] &&
        [object isEqual:self.view.cardExpiryDate]) {
        //self.view.cardFrontView.expiryLabel.text = self.view.cardExpiryDate.text;
    }
}

#pragma mark - VTCardFormatterDelegate

- (void)formatter_didTextFieldChange:(MidtransUICardFormatter *)formatter {
    if (self.installmentAvailable) {
        [self matchBINNumberWithInstallment:[self.view.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    if (self.view.cardNumber.text.length < 1) {
        self.view.cardFrontView.numberLabel.text = @"XXXX XXXX XXXX XXXX";
        self.view.cardFrontView.iconView.image = nil;
        self.view.cardNumber.infoIcon = nil;
    }
    else {
        self.view.cardFrontView.numberLabel.text = self.view.cardNumber.text;
        NSString *originNumber = [self.view.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.view.cardNumber.infoIcon = [self.view iconDarkWithNumber:originNumber];
        self.view.cardFrontView.iconView.image = [self.view iconWithNumber:originNumber];
    }
}


- (void)matchBINNumberWithInstallment:(NSString *)binNumber {
    if (binNumber.length >= 6) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"SELF['bins'] CONTAINS %@",binNumber];
        NSArray *filtered  = [self.binResponseObject filteredArrayUsingPredicate:predicate];
        if (filtered.count) {
            self.filteredBinObject = [[MidtransBinResponse alloc] initWithDictionary:[filtered firstObject]];
            if ([[self.installment.terms objectForKey:self.filteredBinObject.bank] count]) {
                self.installmentBankName = self.filteredBinObject.bank;
                [self.installmentValueObject addObject:@"0"];
                [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:self.filteredBinObject.bank]];
                //[self.view.installmentCollectionView reloadData];
                [UIView transitionWithView:self.view.installmentView
                                  duration:1
                                   options:UIViewAnimationOptionCurveEaseInOut
                                animations:^{
                                    self.view.installmentView.hidden = NO;
                                    self.view.installmentWrapperViewConstraints.constant = installmentHeight;
                                    [self.installmentsContentView configureInstallmentView:self.installmentValueObject];
                                }
                                completion:NULL];
            }
        }
        else if([[self.installment.terms objectForKey:@"offline"] count]){
            self.installmentBankName = @"offline";
            [self.installmentValueObject addObject:@"0"];
            [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:@"offline"]];
            //[self.view.installmentCollectionView reloadData];
            [UIView transitionWithView:self.view.installmentView
                              duration:1
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                self.view.installmentView.hidden = NO;
                                self.view.installmentWrapperViewConstraints.constant = installmentHeight;
                                [self.installmentsContentView configureInstallmentView:self.installmentValueObject];
                            }
                            completion:NULL];
        }
        
    }
    else {
        if (self.installmentValueObject.count > 0) {
            self.installmentCurrentIndex = 0;
            [self.installmentsContentView resetInstallmentIndex];
        }
        self.installmentBankName = @"";
        [UIView transitionWithView:self.view.installmentView
                          duration:1
                           options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            self.view.installmentView.hidden = YES;
                            self.view.installmentWrapperViewConstraints.constant =  0;
                        }
                        completion:NULL];
    }
    
}
#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange :(UITextField *) textField{
    if ([textField isEqual:self.view.cardNumber]) {
        [self.ccFormatter updateTextFieldContentAndPosition];
    }
    //your code
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSError *error;
    
    if ([textField isEqual:self.view.cardExpiryDate]) {
        [textField.text isValidExpiryDate:&error];
    }
    else if ([textField isEqual:self.view.cardNumber]) {
        [textField.text isValidCreditCardNumber:&error];
    }
    else if ([textField isEqual:self.view.cardCvv]) {
        [textField.text isValidCVVWithCreditCardNumber:self.view.cardNumber.text error:&error];
    }
    
    //show warning if error
    if (error) {
        [self.view isViewableError:error];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isKindOfClass:[MidtransUITextField class]]) {
        ((MidtransUITextField *) textField).warning = nil;
    }
    
    if ([textField isEqual:self.view.cardExpiryDate]) {
        return [textField filterCreditCardExpiryDate:string range:range];
    }
    else if ([textField isEqual:self.view.cardNumber]) {
        return [self.ccFormatter updateTextFieldContentAndPosition];
    }
    else if ([textField isEqual:self.view.cardCvv]) {
        return [textField filterCvvNumber:string range:range withCardNumber:self.view.cardNumber.text];
    }
    else {
        return YES;
    }
}

- (void)reformatCardNumber {
    NSString *cardNumber = self.view.cardNumber.text;
    NSString *formatted = [NSString stringWithFormat: @"%@ %@ %@ %@",
                           [cardNumber substringWithRange:NSMakeRange(0,4)],
                           [cardNumber substringWithRange:NSMakeRange(4,4)],
                           [cardNumber substringWithRange:NSMakeRange(8,4)],
                           [cardNumber substringWithRange:NSMakeRange(12,4)]];
    
    self.view.cardNumber.text = formatted;
    self.view.cardNumber.infoIcon = [self.view iconDarkWithNumber:self.view.cardNumber.text];
    
    self.view.cardFrontView.iconView.image = [self.view iconWithNumber:self.view.cardNumber.text];
    self.view.cardFrontView.numberLabel.text = formatted;
}
-(void)installmentSelectedIndex:(NSInteger)index {
    self.installmentCurrentIndex = index;
}

@end
