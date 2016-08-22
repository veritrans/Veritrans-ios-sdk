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
#import "VTCCBackView.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "IHKeyboardAvoiding_vt.h"
#import "UIViewController+Modal.h"
#import "VTThemeManager.h"
#import "VTCCBackView.h"
#import <MidtransCoreKit/VTClient.h>
#import <MidtransCoreKit/VTMerchantClient.h>
#import <MidtransCoreKit/VTPaymentCreditCard.h>
#import <MidtransCoreKit/VTTransactionDetails.h>
#import <MidtransCoreKit/VTCreditCardHelper.h>
#import "VTAddCardView.h"

@interface VTAddCardController ()
@property (strong, nonatomic) IBOutlet VTAddCardView *view;
@property (strong, nonatomic) IBOutlet UIView *saveCardView;
@property (nonatomic) NSMutableArray *maskedCards;
@end

@implementation VTAddCardController
@dynamic view;

- (instancetype)initWithToken:(TransactionTokenResponse *)token maskedCards:(NSMutableArray *)maskedCards {
    if (self = [super initWithToken:token]) {
        self.maskedCards = maskedCards;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = UILocalizedString(@"creditcard.input.title", nil);
    self.view.infoButton.tintColor = [[VTThemeManager shared] themeColor];
    [self addNavigationToTextFields:@[self.view.cardNumber, self.view.cardExpiryDate, self.view.cardCvv]];
    [IHKeyboardAvoiding_vt setAvoidingView:self.view.fieldScrollView];
    [self.view.cardExpiryDate addObserver:self forKeyPath:@"text" options:0 context:nil];
    self.view.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    
    self.saveCardView.hidden = [CC_CONFIG saveCard] == NO;
}

- (void)dealloc {
    [self.view.cardExpiryDate removeObserver:self forKeyPath:@"text"];
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
        [object isEqual:self.view.cardExpiryDate]) {
        self.view.cardFrontView.expiryLabel.text = self.view.cardExpiryDate.text;
    }
}

- (IBAction)textFieldChanged:(id)sender {
    if ([sender isEqual:self.view.cardNumber]) {
        self.view.cardFrontView.iconView.image = [self iconWithNumber:self.view.cardNumber.text];
        self.view.cardFrontView.numberLabel.text = self.view.cardNumber.text;
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

- (IBAction)saveCardSwitchChanged:(UISwitch *)sender {
    [VTCreditCardConfig enableSaveCard:sender.on];
}

- (IBAction)cvvInfoPressed:(UIButton *)sender {
    VTCvvInfoController *guide = [[VTCvvInfoController alloc] init];
    [self.navigationController presentCustomViewController:guide onViewController:self.navigationController completion:nil];
}

- (IBAction)registerPressed:(UIButton *)sender {
    
    VTCreditCard *creditCard = [[VTCreditCard alloc] initWithNumber:self.view.cardNumber.text
                                                         expiryDate:self.view.cardExpiryDate.text
                                                                cvv:self.view.cardCvv.text];
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        [self handleRegisterCreditCardError:error];
        return;
    }
    
    [self showLoadingHud];
    
    BOOL enable3Ds = [CC_CONFIG secure];
    VTTokenizeRequest *tokenRequest = [[VTTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                        grossAmount:self.token.transactionDetails.grossAmount
                                                                             secure:enable3Ds];
    
    [[VTClient sharedClient] generateToken:tokenRequest
                                completion:^(NSString * _Nullable token, NSError * _Nullable error) {
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
        self.view.cardNumber.warning = error.localizedDescription;
    } else if (error.code == -21) {
        //expiry date invalid
        self.view.cardExpiryDate.warning = error.localizedDescription;
    } else if (error.code == -22) {
        //cvv number invalid
        self.view.cardCvv.warning = error.localizedDescription;
    } else {
        [self showAlertViewWithTitle:@"Error"
                          andMessage:error.localizedDescription
                      andButtonTitle:@"Close"];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSError *error;
    
    if ([textField isEqual:self.view.cardExpiryDate]) {
        [textField.text isValidExpiryDate:&error];
    }
    
    if (error) {
        [self handleRegisterCreditCardError:error];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isKindOfClass:[VTTextField class]]) {
        ((VTTextField *) textField).warning = nil;
    }
    
    if ([textField isEqual:self.view.cardExpiryDate]) {
        return [textField filterCreditCardExpiryDate:string range:range];
    }
    else if ([textField isEqual:self.view.cardNumber]) {
        BOOL shouldChange = [textField filterCreditCardWithString:string range:range];
        
        if (shouldChange == NO) {
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
        
        return shouldChange;
    }
    else if ([textField isEqual:self.view.cardCvv]) {
        return [textField filterCvvNumber:string range:range withCardNumber:self.view.cardNumber.text];
    }
    else {
        return YES;
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    VTPaymentCreditCard *paymentDetail = [[VTPaymentCreditCard alloc] initWithCreditCardToken:token token:self.token];
    
    if ([CC_CONFIG saveCard]) {
        paymentDetail.saveToken = self.view.saveCardSwitch.on;
    }
    
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetail];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        }
        else {
            //save masked cards
            if (result.maskedCreditCard) {
                [self.maskedCards addObject:result.maskedCreditCard];
                [[VTMerchantClient sharedClient] saveMaskedCards:self.maskedCards customer:self.token.customerDetails completion:nil];
            }
            
            //transaction finished
            [self handleTransactionSuccess:result];
        }
    }];
}

@end
