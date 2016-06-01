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
#import "VTHudView.h"

#import <MidtransCoreKit/VTClient.h>
#import <MidtransCoreKit/VTMerchantClient.h>
#import <MidtransCoreKit/VTPaymentCreditCard.h>
#import <MidtransCoreKit/VTTransactionDetails.h>
#import <MidtransCoreKit/VTCreditCardHelper.h>

@interface VTAddCardController ()

@property (strong, nonatomic) IBOutlet VTTextField *cardNumber;
@property (strong, nonatomic) IBOutlet VTTextField *cardExpiryDate;
@property (strong, nonatomic) IBOutlet VTTextField *cardCvv;
@property (strong, nonatomic) IBOutlet UIImageView *creditCardLogo;
//@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIScrollView *fieldScrollView;
@property (strong, nonatomic) IBOutlet VTCCFrontView *cardFrontView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (nonatomic) VTKeyboardAccessoryView *keyboardAccessoryView;

@end

@implementation VTAddCardController {
    VTHudView *_hudView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _keyboardAccessoryView = [[VTKeyboardAccessoryView alloc] initWithFrame:CGRectZero fields:@[_cardNumber, _cardExpiryDate, _cardCvv]];
    
    [IHKeyboardAvoiding_vt setAvoidingView:_fieldScrollView];
    
    _hudView = [[VTHudView alloc] init];
    
    [_cardExpiryDate addObserver:self forKeyPath:@"text" options:0 context:nil];
    
    _amountLabel.text = [[NSObject indonesianCurrencyFormatter] stringFromNumber:self.transactionDetails.grossAmount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _creditCardLogo.image = [self iconDarkWithNumber:_cardNumber.text];
        _cardFrontView.iconView.image = [self iconWithNumber:_cardNumber.text];
        _cardFrontView.numberLabel.text = _cardNumber.text;
    }
}

- (UIImage *)iconDarkWithNumber:(NSString *)number {
    switch ([VTCreditCardHelper typeWithNumber:number]) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"VisaDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCBDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCard" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeUnknown:
            return nil;
    }
}

- (UIImage *)iconWithNumber:(NSString *)number {
    switch ([VTCreditCardHelper typeWithNumber:number]) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"Visa" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCB" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCard" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeUnknown:
            return nil;
    }
}

- (IBAction)cvvInfoPressed:(UIButton *)sender {
    VTCvvInfoController *guide = [self.storyboard instantiateViewControllerWithIdentifier:@"VTCvvInfoController"];
    guide.modalSize = guide.preferredContentSize;
    [self presentCustomViewController:guide onViewController:self.navigationController completion:nil];
}

- (IBAction)registerPressed:(UIButton *)sender {
    if ([self expiryDateValid] == NO) return;
    
    [_hudView showOnView:self.view];
    
    NSString *cardNumber = [_cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *dates = [_cardExpiryDate.text componentsSeparatedByString:@"/"];
    NSString *expMonth = dates[0];
    
    NSString *expYear = dates[1];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy";
    NSString *currentYear = [df stringFromDate:[NSDate date]];
    expYear = [[currentYear substringToIndex:currentYear.length-2] stringByAppendingString:expYear];
    
    VTCreditCard *creditCard = [[VTCreditCard alloc] initWithNumber:cardNumber expiryMonth:expMonth expiryYear:expYear cvv:_cardCvv.text];
    
    [[VTClient sharedClient] registerCreditCard:creditCard completion:^(VTMaskedCreditCard *maskedCreditCard, NSError *error) {
        [_hudView hide];
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
        } else {
            [[VTMerchantClient sharedClient] saveRegisteredCard:maskedCreditCard completion:^(id result, NSError *error) {
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                    [alert show];
                } else {
                    if ([self.delegate respondsToSelector:@selector(viewController:didRegisterCard:)]) {
                        [self.delegate viewController:self didRegisterCard:maskedCreditCard];
                    }                
                }
            }];
        }
    }];
}

- (BOOL)expiryDateValid {
    NSArray *dates = [_cardExpiryDate.text componentsSeparatedByString:@"/"];
    if ([dates count] != 2) {
        _cardExpiryDate.warning = @"wrong expiry date format";
        return NO;
    } else {
        return YES;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_cardExpiryDate]) {
        return [textField filterCreditCardExpiryDate:string range:range];
    } else if ([textField isEqual:_cardNumber]) {
        
        BOOL shouldChange = [textField filterCreditCardWithString:string range:range];
        
        if (shouldChange == NO) {
            _creditCardLogo.image = [self iconDarkWithNumber:_cardNumber.text];
            _cardFrontView.iconView.image = [self iconWithNumber:_cardNumber.text];
            _cardFrontView.numberLabel.text = _cardNumber.text;
        }
        
        return shouldChange;
        
    } else if ([textField isEqual:_cardCvv]) {
        return [textField filterCvvNumber:string range:range];
    } else {
        return YES;
    }
}

@end
