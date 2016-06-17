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
#import "VTKeyboardAccessoryView.h"
#import "UIViewController+Modal.h"
#import "VTCardControllerConfig.h"

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
@property (nonatomic) VTKeyboardAccessoryView *keyboardAccessoryView;

@end

@implementation VTAddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _keyboardAccessoryView = [[VTKeyboardAccessoryView alloc] initWithFrame:CGRectZero fields:@[_cardNumber, _cardExpiryDate, _cardCvv]];
    
    [IHKeyboardAvoiding_vt setAvoidingView:_fieldScrollView];
    
    [_cardExpiryDate addObserver:self forKeyPath:@"text" options:0 context:nil];
    
    _amountLabel.text = [[NSObject indonesianCurrencyFormatter] stringFromNumber:self.transactionDetails.grossAmount];
}

- (void)dealloc {
    [_cardExpiryDate removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] &&
        [object isEqual:_cardExpiryDate]) {
        _cardFrontView.expiryLabel.text = _cardExpiryDate.text;
    }
}

- (IBAction)textFieldChanged:(id)sender {
    if ([sender isEqual:_cardNumber]) {
        _cardFrontView.iconView.image = [self iconWithNumber:_cardNumber.text];
        _cardFrontView.numberLabel.text = _cardNumber.text;
    }
}

- (UIImage *)iconDarkWithNumber:(NSString *)number {
    switch ([VTCreditCardHelper typeFromString:number]) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"VisaDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCBDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCard" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeAmex:
            return [UIImage imageNamed:@"Amex" inBundle:VTBundle compatibleWithTraitCollection:nil];
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
    VTCvvInfoController *guide = [self.storyboard instantiateViewControllerWithIdentifier:@"VTCvvInfoController"];
    guide.modalSize = guide.preferredContentSize;
    [self presentCustomViewController:guide onViewController:self.navigationController completion:nil];
}

- (IBAction)registerPressed:(UIButton *)sender {
    if (self.cardNumber.text.isEmpty) {
        self.cardNumber.warning =@"Cannot Be Empty";
        return;
    }
    else if (self.cardExpiryDate.text.isEmpty) {
        self.cardExpiryDate.warning =@"Cannot Be Empty";
        return;
    }
    else if (self.cardCvv.text.isEmpty) {
        self.cardCvv.warning =@"Cannot Be Empty";
        return;
    }
    [self showLoadingHud];
    NSString *cardNumber = [_cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *dates = [_cardExpiryDate.text componentsSeparatedByString:@"/"];
    NSString *expMonth = dates[0];
    NSString *expYear = dates.count == 2 ? dates[1] : nil;
    
    VTCreditCard *creditCard = [[VTCreditCard alloc] initWithNumber:cardNumber
                                                        expiryMonth:expMonth
                                                         expiryYear:expYear
                                                                cvv:_cardCvv.text];
    
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        [self handleRegisterCreditCardError:error];
        return;
    }
    
    BOOL enable3Ds = [[VTCardControllerConfig sharedInstance] enable3DSecure];
    VTTokenizeRequest *tokenRequest = [[VTTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                        grossAmount:self.transactionDetails.grossAmount
                                                                             secure:enable3Ds];
    
    [[VTClient sharedClient] generateToken:tokenRequest completion:^(NSString *token, NSString *redirectURL, NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        } else {
            if (redirectURL) {
                VT3DSController *secureController = [[VT3DSController alloc] initWithToken:token
                                                                                 secureURL:[NSURL URLWithString:redirectURL]];
                [secureController showWithCompletion:^(NSError *error) {
                    if (error) {
                        [self handleTransactionError:error];
                    } else {
                        [self payWithToken:token];
                    }
                }];
            } else {
                [self payWithToken:token];
            }
        }
    }];
}

- (void)handleRegisterCreditCardError:(NSError *)error {
    [self hideLoadingHud];
    if (error.code == -20) {
        //number invalid
        _cardNumber.warning = error.localizedDescription;
    } else if (error.code == -21) {
        //expiry date invalid
        _cardExpiryDate.warning = error.localizedDescription;
    } else if (error.code == -22) {
        //cvv number invalid
        _cardCvv.warning = error.localizedDescription;
    } else {
        //other error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isKindOfClass:[VTTextField class]]) {
        ((VTTextField *) textField).warning = nil;
    }
    
    if ([textField isEqual:_cardExpiryDate]) {
        return [textField filterCreditCardExpiryDate:string range:range];
    } else if ([textField isEqual:_cardNumber]) {
        
        BOOL shouldChange = [textField filterCreditCardWithString:string range:range];
        
        if (shouldChange == NO) {
            _cardFrontView.numberLabel.text = _cardNumber.text;
            NSString *originNumber = [_cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            _cardNumber.infoIcon = [self iconDarkWithNumber:originNumber];
            _cardFrontView.iconView.image = [self iconWithNumber:originNumber];
        }
        
        return shouldChange;
        
    } else if ([textField isEqual:_cardCvv]) {
        return [textField filterCvvNumber:string range:range withCardNumber:_cardNumber.text];
    } else {
        return YES;
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    VTPaymentCreditCard *paymentDetail = [[VTPaymentCreditCard alloc] initWithFeature:VTCreditCardPaymentFeatureNormal token:token];
    paymentDetail.saveToken = _saveCardSwitch.on;
    
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetail transactionDetails:self.transactionDetails customerDetails:self.customerDetails itemDetails:self.itemDetails];
    
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

@end
