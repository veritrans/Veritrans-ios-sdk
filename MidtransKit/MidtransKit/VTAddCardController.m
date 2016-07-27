//
//  VTAddCardController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTAddCardController.h"
#import "VTClassHelper.h"
#import "VTTextField.h"
#import "VTCvvInfoController.h"
#import "VTCCFrontView.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "IHKeyboardAvoiding_vt.h"
#import "UIViewController+Modal.h"
#import "VTCardControllerConfig.h"
#import "VTThemeManager.h"

#import <MidtransCoreKit/VTClient.h>
#import <MidtransCoreKit/VTMerchantClient.h>
#import <MidtransCoreKit/VTPaymentCreditCard.h>
#import <MidtransCoreKit/VTTransactionDetails.h>
#import <MidtransCoreKit/VTCreditCardHelper.h>

@interface VTAddCardController ()

@property (strong, nonatomic) IBOutlet VTTextField *cardNumber;
@property (strong, nonatomic) IBOutlet VTTextField *cardExpiryDate;
@property (strong, nonatomic) IBOutlet VTTextField *cardCvv;
@property (strong, nonatomic) IBOutlet UIScrollView *fieldScrollView;
@property (strong, nonatomic) IBOutlet VTCCFrontView *cardFrontView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UISwitch *saveCardSwitch;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation VTAddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = UILocalizedString(@"creditcard.input.title", nil);
    self.infoButton.tintColor = [[VTThemeManager shared] themeColor];
    [self addNavigationToTextFields:@[self.cardNumber, self.cardExpiryDate, self.cardCvv]];
    [IHKeyboardAvoiding_vt setAvoidingView:self.fieldScrollView];
    [self.cardExpiryDate addObserver:self forKeyPath:@"text" options:0 context:nil];
    self.amountLabel.text = self.transactionDetails.grossAmount.formattedCurrencyNumber;
}

- (void)dealloc {
    [self.cardExpiryDate removeObserver:self forKeyPath:@"text"];
}

- (void)handleTransactionSuccess:(VTTransactionResult *)result {
    [super handleTransactionSuccess:result];
    [self hideLoadingHud];
}

- (void)handleTransactionError:(NSError *)error {
    [super handleTransactionError:error];
    [self hideLoadingHud];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] &&
        [object isEqual:self.cardExpiryDate]) {
        self.cardFrontView.expiryLabel.text = self.cardExpiryDate.text;
    }
}

- (IBAction)textFieldChanged:(id)sender {
    if ([sender isEqual:self.cardNumber]) {
        self.cardFrontView.iconView.image = [self iconWithNumber:self.cardNumber.text];
        self.cardFrontView.numberLabel.text = self.cardNumber.text;
    }
}

- (UIImage *)iconDarkWithNumber:(NSString *)number {
    switch ([VTCreditCardHelper typeFromString:number]) {
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
    switch ([VTCreditCardHelper typeFromString:number]) {
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

- (IBAction)cvvInfoPressed:(UIButton *)sender {
    VTCvvInfoController *guide = [[VTCvvInfoController alloc] init];
    [self.navigationController presentCustomViewController:guide onViewController:self.navigationController completion:nil];
}

- (IBAction)registerPressed:(UIButton *)sender {
    NSString *cardNumber = [self.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *dates = [self.cardExpiryDate.text componentsSeparatedByString:@"/"];
    NSString *expMonth = dates[0];
    NSString *expYear = dates.count == 2 ? dates[1] : nil;
    
    VTCreditCard *creditCard = [[VTCreditCard alloc] initWithNumber:cardNumber
                                                        expiryMonth:expMonth
                                                         expiryYear:expYear
                                                                cvv:self.cardCvv.text];
    
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        [self handleRegisterCreditCardError:error];
        return;
    }
    
    [self showLoadingHud];
    
    BOOL enable3Ds = [[VTCardControllerConfig sharedInstance] enable3DSecure];
    VTTokenizeRequest *tokenRequest = [[VTTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                        grossAmount:self.transactionDetails.grossAmount
                                                                             secure:enable3Ds];
    
    [[VTClient sharedClient] generateToken:tokenRequest completion:^(NSString * _Nullable token, NSError * _Nullable error) {
        if (error) {
            
            [self hideLoadingHud];
            [self handleTransactionError:error];
        } else {
            [self payWithToken:token];
        }
    }];
}

- (void)handleRegisterCreditCardError:(NSError *)error {
    [self hideLoadingHud];
    if (error.code == -20) {
        //number invalid
        self.cardNumber.warning = error.localizedDescription;
    } else if (error.code == -21) {
        //expiry date invalid
        self.cardExpiryDate.warning = error.localizedDescription;
    } else if (error.code == -22) {
        //cvv number invalid
        self.cardCvv.warning = error.localizedDescription;
    } else {
        [self showAlertViewWithTitle:@"Error"
                          andMessage:error.localizedDescription
                      andButtonTitle:@"Close"];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isKindOfClass:[VTTextField class]]) {
        ((VTTextField *) textField).warning = nil;
    }
    
    if ([textField isEqual:self.cardExpiryDate]) {
        return [textField filterCreditCardExpiryDate:string range:range];
    } else if ([textField isEqual:self.cardNumber]) {
        
        BOOL shouldChange = [textField filterCreditCardWithString:string range:range];
        
        if (shouldChange == NO) {
            if (self.cardNumber.text.length<1) {
                self.cardFrontView.numberLabel.text = @"XXXX XXXX XXXX XXXX";
                self.cardFrontView.iconView.image = nil;
                self.cardNumber.infoIcon = nil;
            }
            else {
                self.cardFrontView.numberLabel.text = self.cardNumber.text;
                NSString *originNumber = [self.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                self.cardNumber.infoIcon = [self iconDarkWithNumber:originNumber];
                self.cardFrontView.iconView.image = [self iconWithNumber:originNumber];
            }
        }
        
        return shouldChange;
        
    } else if ([textField isEqual:self.cardCvv]) {
        return [textField filterCvvNumber:string range:range withCardNumber:self.cardNumber.text];
    } else {
        return YES;
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    VTPaymentCreditCard *paymentDetail = [[VTPaymentCreditCard alloc] initWithFeature:VTCreditCardPaymentFeatureNormal token:token];
    paymentDetail.saveToken = _saveCardSwitch.on;
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetail
                                                            transactionDetails:self.transactionDetails
                                                               customerDetails:self.customerDetails
                                                                   itemDetails:self.itemDetails];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

@end
