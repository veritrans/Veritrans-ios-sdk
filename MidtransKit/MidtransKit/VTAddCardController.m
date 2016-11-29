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
#import "MidtransUICardFormatter.h"
#import "VTAddCardView.h"
#import "MidtransLoadingView.h"
#import "VTCollectionViewLayout.h"
#import "VTInstallmentCollectionViewCell.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransPaymentRequestV2Installment.h>
static const NSInteger installmentHeight = 44;
#if __has_include(<CardIO/CardIO.h>)
#import <CardIO/CardIO.h>
@interface VTAddCardController () <CardIOPaymentViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDelegate,MidtransUICardFormatterDelegate,UITextFieldDelegate,MidtransUICardFormatterDelegate>
#else
@interface VTAddCardController () <UICollectionViewDelegate,UICollectionViewDelegate,UITextFieldDelegate,MidtransUICardFormatterDelegate>
#endif

@property (strong, nonatomic) IBOutlet VTAddCardView *view;
@property (nonatomic,strong) NSMutableArray *maskedCards;
@property (nonatomic) BOOL installmentAvailable;
@property (nonatomic,strong)NSArray *binResponseObject;
@property (nonatomic,strong)NSArray *installmentValueObject;
@property (nonatomic,strong)MidtransBinResponse *filteredBinObject;
@property (nonatomic,strong)MidtransPaymentRequestV2CreditCard *creditCardData;
@property (nonatomic,strong)MidtransTransactionTokenResponse *snap_token;
@property (nonatomic,strong)MidtransPaymentListModel *paymentMethodOveride;
@property (nonatomic)NSInteger installmentCurrentIndex;
@end

@implementation VTAddCardController

@dynamic view;
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token paymentMethodName:(MidtransPaymentListModel *)paymentMethod andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard {
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        self.snap_token = token;
        self.paymentMethodOveride = paymentMethod;
        self.creditCardData = creditCard;
    }
    return self;
}
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token maskedCards:(NSMutableArray *)maskedCards {
    if (self = [super initWithToken:token]) {
        self.snap_token = token;
        self.maskedCards = maskedCards;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.installmentCurrentIndex = 0;
      self.view.installmentCollectionView.collectionViewLayout = [[VTCollectionViewLayout alloc] initWithColumn:1 andHeight:installmentHeight];
    [self.view.installmentCollectionView registerNib:[UINib nibWithNibName:@"VTInstallmentCollectionViewCell" bundle:VTBundle]
               forCellWithReuseIdentifier:@"installmentCell"];
    self.view.installmentCollectionView.pagingEnabled = YES;
    self.view.ccFormatter = [[MidtransUICardFormatter alloc] initWithTextField:self.view.cardNumber];
    self.view.ccFormatter.delegate = self;
    self.view.ccFormatter.numberLimit = 16;
    [self.view.cardExpiryDate addObserver:self forKeyPath:@"text" options:0 context:nil];
    self.view.installmentWrapperViewHeightConstraints.constant = 0.0f;
    self.view.installmentWrapperView.hidden = YES;
    self.title = UILocalizedString(@"creditcard.input.title", nil);
    [self addNavigationToTextFields:@[self.view.cardNumber, self.view.cardExpiryDate, self.view.cardCvv]];
    if ([CC_CONFIG paymentType] == MTCreditCardPaymentTypeNormal) {
        self.view.saveCardView.hidden = YES;
        self.view.saveCardViewHeightConstaints.constant = 0.0f;
    }
    else {
        self.view.saveCardView.hidden = NO;
        self.view.saveCardViewHeightConstaints.constant = 77.0f;
    }
    self.view.amountLabel.text = self.snap_token.transactionDetails.grossAmount.formattedCurrencyNumber;
    MidtransPaymentRequestV2Installment *installment = self.creditCardData.installments;
    self.installmentAvailable = NO;
    if (installment.terms) {
        self.installmentAvailable = YES;
        [[MidtransClient shared] requestCardBINForInstallmentWithCompletion:^(NSArray *binResponse, NSError * _Nullable error) {
            if (!error) {
                self.binResponseObject = binResponse;
            }

        }];
    }
    self.view.saveCardSwitch.on = [CC_CONFIG saveCard];
    
#if __has_include(<CardIO/CardIO.h>)
     [self hideScanCardButton:YES];
   // [self.view hideScanCardButton:NO];
    //speedup cardio launch
   // [CardIOUtilities preloadCardIO];
#else
    [self hideScanCardButton:YES];
#endif
}
- (void)handleTransactionResult:(MidtransTransactionResult *)result {
    [super handleTransactionResult:result];
    [self.view.loadingView hide];
}
- (void)handleTransactionSuccess:(MidtransTransactionResult *)result {
    [super handleTransactionSuccess:result];
    [self.view.loadingView hide];
}

- (void)handleTransactionError:(NSError *)error {
    [super handleTransactionError:error];
                                        [self.view.loadingView hide];
}

- (IBAction)saveCardSwitchChanged:(UISwitch *)sender {
    [MidtransCreditCardConfig enableSaveCard:sender.on];
}

- (IBAction)cvvInfoPressed:(UIButton *)sender {
    VTCvvInfoController *guide = [[VTCvvInfoController alloc] init];
    [self.navigationController presentCustomViewController:guide onViewController:self.navigationController completion:nil];
}

- (IBAction)registerPressed:(UIButton *)sender {
    MidtransCreditCard *creditCard = [[MidtransCreditCard alloc] initWithNumber:self.view.cardNumber.text
                                                                     expiryDate:self.view.cardExpiryDate.text
                                                                            cvv:self.view.cardCvv.text];

    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        [self handleRegisterCreditCardError:error];
        return;
    }
    
      [self.view.loadingView showWithTitle:@"Processing your transaction"];
    
    BOOL enable3Ds = [CC_CONFIG secure];
    MidtransTokenizeRequest *tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                                    grossAmount:self.snap_token.transactionDetails.grossAmount
                                                                                         secure:enable3Ds];
    
    [[MidtransClient shared] generateToken:tokenRequest
                                completion:^(NSString * _Nullable token, NSError * _Nullable error) {
                                    if (error) {
                                        [self handleTransactionError:error];
                                    } else {
                                        [self payWithToken:token];
                                    }
                                }];
}

- (void)handleRegisterCreditCardError:(NSError *)error {
    [self.view.loadingView hide];
    
    if ([self isViewError:error] == NO) {
        [self showAlertViewWithTitle:@"Error"
                          andMessage:error.localizedDescription
                      andButtonTitle:@"Close"];
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard paymentWithToken:token customer:self.snap_token.customerDetails];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:self.snap_token];
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        }
        else {
            if ([CC_CONFIG tokenStorageDisabled] && result.maskedCreditCard) {
                [self.maskedCards addObject:result.maskedCreditCard];
                [[MidtransMerchantClient shared] saveMaskedCards:self.maskedCards customer:self.snap_token.customerDetails completion:^(id  _Nullable result, NSError * _Nullable error) {
                    
                }];
            }
            if ([[result.additionalData objectForKey:@"fraud_status"] isEqualToString:@"challenge"]) {
                [self handleTransactionResult:result];
            }
            else {
                [self handleTransactionSuccess:result];
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
    [self reformatCardNumber];
    
    self.view.cardCvv.text = cardInfo.cvv;
    
    self.view.cardExpiryDate.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)cardInfo.expiryMonth, (unsigned long)cardInfo.expiryYear];
}

#endif
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] &&
        [object isEqual:self.view.cardExpiryDate]) {
        self.view.cardFrontView.expiryLabel.text = self.view.cardExpiryDate.text;
    }
}

- (UIImage *)iconDarkWithNumber:(NSString *)number {
    switch ([MidtransCreditCardHelper typeFromString:number]) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"VisaDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCBDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCardDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeAmex:
            return [UIImage imageNamed:@"AmexDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        default:
            return nil;
    }
}

- (UIImage *)iconWithNumber:(NSString *)number {
    switch ([MidtransCreditCardHelper typeFromString:number]) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"Visa" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCB" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCard" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeAmex:
            return [UIImage imageNamed:@"Amex" inBundle:VTBundle compatibleWithTraitCollection:nil];
        default:
            return nil;
    }
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange :(UITextField *) textField{
    if ([textField isEqual:self.view.cardNumber]) {
        [self.view.ccFormatter updateTextFieldContentAndPosition];
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
        [self isViewError:error];
    }
}
- (void)matchBINNumberWithInstallment:(NSString *)binNumber {
    if (binNumber.length >= 6) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                          @"SELF['bins'] CONTAINS %@",binNumber];
        NSArray *filtered  = [self.binResponseObject filteredArrayUsingPredicate:predicate];
        if (filtered.count) {
            self.filteredBinObject = [[MidtransBinResponse alloc] initWithDictionary:[filtered firstObject]];
            if ([[[self.creditCardData.installments terms] objectForKey:self.filteredBinObject.bank] count]) {
                self.installmentValueObject = [[self.creditCardData.installments terms] objectForKey:self.filteredBinObject.bank];
                [self.view.installmentCollectionView reloadData];
                [UIView transitionWithView:self.view.installmentWrapperView
                                  duration:1
                                   options:UIViewAnimationOptionCurveEaseIn
                                animations:^{
                                    self.view.installmentWrapperView.hidden = NO;
                                    self.view.installmentWrapperViewHeightConstraints.constant = installmentHeight;
                                }
                                completion:NULL];
            }

        }

    }
    else {
        [UIView transitionWithView:self.view.installmentWrapperView
                          duration:1
                           options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            self.view.installmentWrapperView.hidden = YES;
                            self.view.installmentWrapperViewHeightConstraints.constant =  0;
                        }
                        completion:NULL];
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
        return [self.view.ccFormatter updateTextFieldContentAndPosition];
    }
    else if ([textField isEqual:self.view.cardCvv]) {
        return [textField filterCvvNumber:string range:range withCardNumber:self.view.cardNumber.text];
    }
    else {
        return YES;
    }
}


- (BOOL)isViewError:(NSError *)error {
    if (error.code == -20) {
        //number invalid
        self.view.cardNumber.warning = error.localizedDescription;
        return YES;
    }
    else if (error.code == -21) {
        //expiry date invalid
        self.view.cardExpiryDate.warning = error.localizedDescription;
        return YES;
    }
    else if (error.code == -22) {
        //cvv number invalid
        self.view.cardCvv.warning = error.localizedDescription;
        return YES;
    }
    else {
        return NO;
    }
}

- (void)hideScanCardButton:(BOOL)hide {
    if (hide) {
        //self.view.scanCardButton.hidden = YES;
        //self.view.scanCardHeight.constant = 0;
    }
    else {
//        self.view.scanCardButton.hidden = NO;
//        self.view.scanCardHeight.constant = ScanButtonHeight;
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
    self.view.cardNumber.infoIcon = [self iconDarkWithNumber:self.view.cardNumber.text];

    self.view.cardFrontView.iconView.image = [self iconWithNumber:self.view.cardNumber.text];
    self.view.cardFrontView.numberLabel.text = formatted;
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
        self.view.cardNumber.infoIcon = [self iconDarkWithNumber:originNumber];
        self.view.cardFrontView.iconView.image = [self iconWithNumber:originNumber];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.view.cardExpiryDate removeObserver:self forKeyPath:@"text"];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.installmentValueObject.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VTInstallmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"installmentCell" forIndexPath:indexPath];
    [cell configureInstallment:self.installmentValueObject[indexPath.row]];
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;

}
- (IBAction)prevButtonDidTapped:(id)sender {
    if (self.installmentCurrentIndex >0) {
          self.installmentCurrentIndex --;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.installmentCurrentIndex inSection:0];
        [self.view.installmentCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }


}
- (IBAction)nextButtonDidTapped:(id)sender {

    if (self.installmentCurrentIndex <self.installmentValueObject.count-1) {
        self.installmentCurrentIndex ++;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.installmentCurrentIndex inSection:0];
        [self.view.installmentCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }



}
@end
