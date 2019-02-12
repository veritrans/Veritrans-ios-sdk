//
//  VTTwoClickController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/4/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTTwoClickController.h"
#import "VTCardListController.h"
#import "MidtransUITextField.h"
#import "VTClassHelper.h"
#import "VTCCBackView.h"
#import "MidtransUICCFrontView.h"
#import "PopAnimator.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransPaymentRequestV2DataModels.h>
#import <MidtransCoreKit/MidtransBinResponse.h>
#import <MidtransCoreKit/MidtransPaymentRequestV2Installment.h>
#import "VTPaymentStatusViewModel.h"
#import "IHKeyboardAvoiding_vt.h"
#import "MidtransInstallmentView.h"
static dispatch_once_t * onceToken;

@interface VTTwoClickController () <UINavigationControllerDelegate,MidtransInstallmentViewDelegate>

@property (nonatomic) IBOutlet MidtransUITextField *cvvTextField;
@property (nonatomic,strong)NSMutableArray *installmentValueObject;
@property (nonatomic) NSArray *bins;
@property (nonatomic) NSArray *bankBinList;
@property (nonatomic,strong) NSString *installmentBankName;
@property (nonatomic,strong) MidtransInstallmentView *installmentsContentView;
@property (nonatomic,strong) MidtransPaymentRequestV2Installment *installment;
@property (nonatomic,strong) NSArray *binResponseObject;
@property (nonatomic,strong) MidtransBinResponse *filteredBinObject;
@property (nonatomic) BOOL installmentAvailable,installmentRequired;
@property (strong, nonatomic) IBOutlet UIScrollView *fieldScrollView;
@property (nonatomic) MidtransMaskedCreditCard *maskeCard;
@property (nonatomic) NSInteger installmentCurrentIndex;
@property (nonatomic,strong) MidtransPaymentRequestV2CreditCard *creditCardInfo;
@property (weak, nonatomic) IBOutlet UIView *installmentVIew;

@end

@implementation VTTwoClickController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                   maskedCard:(MidtransMaskedCreditCard *)maskedCard {
    self = [super initWithToken:token paymentMethodName:paymentMethod];
    if (self) {
        self.maskeCard = maskedCard;
    }
    return self;
}
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                   maskedCard:(MidtransMaskedCreditCard *)maskedCard
            andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard {
    self = [super initWithToken:token paymentMethodName:paymentMethod];
    if (self) {
        self.maskeCard = maskedCard;
        self.creditCardInfo = creditCard;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.installmentVIew.hidden = NO;
    self.installmentValueObject = [NSMutableArray new];
    self.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.twoclick.title"];
    [self addNavigationToTextFields:@[self.cvvTextField]];
    self.navigationController.delegate = self;
    
    self.bankBinList = [NSJSONSerialization JSONObjectWithData:[[NSData alloc]
                                                                initWithContentsOfFile:[VTBundle pathForResource:@"bin" ofType:@"json"]]
                                                       options:kNilOptions error:nil];
    
    self.installment = [[MidtransPaymentRequestV2Installment alloc]
                        initWithDictionary: [[self.creditCardInfo dictionaryRepresentation] valueForKey:@"installment"]];
    
    if (self.installment.terms) {
        self.installmentAvailable = YES;
        self.installmentRequired = self.installment.required;
        [self setupInstallmentView];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(self.installmentAvailable) forKey:MIDTRANS_TRACKING_INSTALLMENT_AVAILABLE];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.installmentRequired) forKey:MIDTRANS_TRACKING_INSTALLMENT_REQUIRED];
    [[SNPUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:@{@"installment available": @(self.installmentAvailable), @"installment required": @(self.installmentRequired)}];
    self.bins = self.creditCardInfo.whitelistBins;
}

- (void)setupInstallmentView {
    NSArray *subviewArray = [VTBundle loadNibNamed:@"MidtransInstallmentView" owner:self options:nil];
    self.installmentsContentView = [subviewArray objectAtIndex:0];
    self.installmentsContentView.delegate = self;
    [self.installmentVIew  addSubview:self.installmentsContentView];
    [self.installmentsContentView setupInstallmentCollection];
    NSString *cardNumber= [[self.maskeCard.maskedNumber componentsSeparatedByString:@"-"] firstObject];
    [self matchBINNumberWithInstallment:cardNumber];
}

- (void)matchBINNumberWithInstallment:(NSString *)binNumber {
    static dispatch_once_t once_token;
    onceToken = &once_token;
    if (binNumber.length >= 6) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"SELF['bins'] CONTAINS %@",binNumber];
        NSArray *filtered  = [self.bankBinList filteredArrayUsingPredicate:predicate];
        dispatch_once(&once_token, ^{
            if (filtered.count) {
                self.filteredBinObject = [[MidtransBinResponse alloc] initWithDictionary:[filtered firstObject]];
                if (self.installmentAvailable) {
                    self.installmentBankName = self.filteredBinObject.bank;
                    [self.installmentValueObject addObject:@"0"];
                    [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:self.filteredBinObject.bank]];
                    [self showInstallmentView:YES];
                }
            }
            else {
                if ([[self.installment.terms objectForKey:@"offline"] count]) {
                    self.installmentBankName = @"offline";
                    [self.installmentValueObject addObject:@"0"];
                    [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:@"offline"]];
                    [self showInstallmentView:YES];
                }
                
            }
        });
        
    }
    else {
        *onceToken = 0;
        self.filteredBinObject.bank = nil;
        if (self.installmentValueObject.count > 0) {
            self.installmentCurrentIndex = 0;
            [self.installmentValueObject removeAllObjects];
            [self.installmentsContentView resetInstallmentIndex];
        }
        [self showInstallmentView:NO];
        
    }
    
}
- (void)showInstallmentView:(BOOL)show {
    [UIView transitionWithView:self.installmentVIew
                      duration:1
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.installmentVIew.hidden = !show;
                        [self.installmentsContentView.installmentCollectionView reloadData];
                        [self.installmentsContentView configureInstallmentView:self.installmentValueObject];
                    }
     
                    completion:NULL];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.cvvTextField becomeFirstResponder];
    
    [IHKeyboardAvoiding_vt setAvoidingView:self.fieldScrollView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPop)
    return [[PopAnimator alloc] init];
    
    return nil;
}

- (IBAction)paymentPressed:(UIButton *)sender {
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    
    MidtransTokenizeRequest *tokenRequest;
    
    if (self.installment.terms && self.installmentCurrentIndex !=0) {
        NSInteger installment =[[[self.installment.terms  objectForKey:self.installmentBankName] objectAtIndex:self.installmentCurrentIndex -1] integerValue];
        tokenRequest = [[MidtransTokenizeRequest alloc] initWithTwoClickToken:self.maskeCard.savedTokenId cvv:self.cvvTextField.text grossAmount:self.token.transactionDetails.grossAmount installment:YES installmentTerm:[NSNumber numberWithInteger:installment]];
    }
    else {
        tokenRequest = [[MidtransTokenizeRequest alloc] initWithTwoClickToken:self.maskeCard.savedTokenId
                                                                          cvv:self.cvvTextField.text
                                                                  grossAmount:self.token.transactionDetails.grossAmount];
    }
    
    
    
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.cvvTextField]) {
        return [textField filterCvvNumber:string
                                    range:range
                           withCardNumber:self.maskeCard.maskedNumber];
    } else {
        return YES;
    }
}

#pragma mark - Helper
-(void)installmentSelectedIndex:(NSInteger)index {
    self.installmentCurrentIndex = index;
}

- (void)payWithToken:(NSString *)token {
    [self.view endEditing:YES];
    NSString *installmentTerms = @"";
    if (self.installmentAvailable && self.installmentCurrentIndex!=0) {
        installmentTerms = [NSString stringWithFormat:@"%@_%@",self.installmentBankName, [[self.installment.terms  objectForKey:self.installmentBankName] objectAtIndex:self.installmentCurrentIndex -1]];
    }
    if (self.installmentRequired && self.installmentCurrentIndex==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:[VTClassHelper getTranslationFromAppBundleForString:@"This transaction must use installment"]
                                                       delegate:nil
                                              cancelButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard modelWithToken:token customer:self.token.customerDetails saveCard:NO installment:installmentTerms];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:self.token];
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

@end
