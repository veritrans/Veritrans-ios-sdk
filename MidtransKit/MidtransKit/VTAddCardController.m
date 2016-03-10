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
#import "UIViewController+Modal.h"
#import "VTCVVGuideController.h"
#import "VTCCFrontView.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"

#import <MidtransCoreKit/VTClient.h>
#import <MidtransCoreKit/VTMerchantClient.h>
#import <MidtransCoreKit/VTPaymentCreditCard.h>
#import <MidtransCoreKit/VTCTransactionDetails.h>

@interface VTAddCardController ()
@property (strong, nonatomic) IBOutlet VTTextField *cardName;
@property (strong, nonatomic) IBOutlet VTTextField *cardNumber;
@property (strong, nonatomic) IBOutlet VTTextField *cardExpiryDate;
@property (strong, nonatomic) IBOutlet VTTextField *cardCvv;
@property (strong, nonatomic) IBOutlet UISwitch *saveStateSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *creditCardLogo;
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIScrollView *containerTextField;
@property (strong, nonatomic) IBOutlet VTCCFrontView *cardFrontView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic, readwrite) VTCustomerDetails *customer;
@property (nonatomic, readwrite) NSArray *items;
@end

@implementation VTAddCardController {
    __weak UITextField *selectedTextField;
}

+ (instancetype)controllerWithCustomer:(VTCustomerDetails *)customer items:(NSArray *)items {
    VTAddCardController *vc = [[UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle] instantiateViewControllerWithIdentifier:@"VTAddCardController"];
    vc.customer = customer;
    vc.items = items;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_cardExpiryDate addObserver:self forKeyPath:@"text" options:0 context:nil];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *amount = [_items itemsPriceAmount];
    
    _amountLabel.text = [NSString stringWithFormat:@"Rp %@", [formatter stringFromNumber:amount]]; //[[_items itemsPriceAmount] stringValue];// [NSString stringWithFormat:@"Rp %@", [formatter stringFromNumber:[_items itemsPriceAmount]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_cardExpiryDate removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:selectedTextField];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] &&
        [object isEqual:_cardExpiryDate]) {
        _cardFrontView.expiryLabel.text = _cardExpiryDate.text;
    }
}

- (IBAction)textFieldChanged:(id)sender {
    if ([sender isEqual:_cardName]) {
        _cardFrontView.holderNameLabel.text = _cardName.text;
    } else if ([sender isEqual:_cardNumber]) {
        _creditCardLogo.image = [self iconDarkWithNumber:_cardNumber.text];
        _cardFrontView.iconView.image = [self iconWithNumber:_cardNumber.text];
        _cardFrontView.numberLabel.text = _cardNumber.text;
    }
}

- (UIImage *)iconDarkWithNumber:(NSString *)number {
    VTCreditCardType type = [VTCreditCard typeWithNumber:number];
    switch (type) {
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
    VTCreditCardType type = [VTCreditCard typeWithNumber:number];
    switch (type) {
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
    VTCVVGuideController *guide = [self.storyboard instantiateViewControllerWithIdentifier:@"VTCVVGuideController"];
    guide.modalSize = guide.preferredContentSize;
    [self presentCustomViewController:guide
             presentingViewController:self.navigationController
                           completion:nil];
}

- (IBAction)paymentPressed:(UIButton *)sender {
    NSArray *dates = [_cardExpiryDate.text componentsSeparatedByString:@"/"];
    if ([dates count] != 2) {
        _cardExpiryDate.warning = @"wrong expiry date format";
        return;
    }
    
    NSString *expMonth = dates[0];
    NSString *expYear = dates[1];
    
    NSString *cardNumber = [_cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSNumber *grossAmount = [_items itemsPriceAmount];
    
    
    VTCreditCard *creditCard = [VTCreditCard cardWithNumber:cardNumber expiryMonth:expMonth expiryYear:expYear cvv:_cardCvv.text holder:_cardName.text];
    VTTokenRequest *tokenRequest = [VTTokenRequest tokenFor3DSecureTransactionWithCreditCard:creditCard bank:nil secure:YES grossAmount:grossAmount];
    [[VTClient sharedClient] generateToken:tokenRequest completion:^(NSString *token, NSError *error) {
        if (token) {
            VTPaymentCreditCard *payDetail = [VTPaymentCreditCard paymentForTokenId:token];
            VTCTransactionDetails *transDetail = [[VTCTransactionDetails alloc] initWithGrossAmount:grossAmount];
            
            
            VTCTransactionData *transactionData = [[VTCTransactionData alloc] initWithpaymentDetails:payDetail transactionDetails:transDetail customerDetails:_customer itemDetails:_items];
            [[VTMerchantClient sharedClient] performCreditCardTransaction:transactionData completion:^(id response, NSError *error) {
                
            }];
        }
    }];
}

- (IBAction)nextFieldPressed:(id)sender {
    if ([selectedTextField isEqual:_cardNumber]) {
        [_cardExpiryDate becomeFirstResponder];
    } else if ([selectedTextField isEqual:_cardExpiryDate]) {
        [_cardCvv becomeFirstResponder];
    } else if ([selectedTextField isEqual:_cardCvv]) {
        [_cardName becomeFirstResponder];
    } else {
        [_cardNumber becomeFirstResponder];
    }
}

- (IBAction)prevFieldPressed:(id)sender {
    if ([selectedTextField isEqual:_cardNumber]) {
        [_cardName becomeFirstResponder];
    } else if ([selectedTextField isEqual:_cardExpiryDate]) {
        [_cardNumber becomeFirstResponder];
    } else if ([selectedTextField isEqual:_cardCvv]) {
        [_cardExpiryDate becomeFirstResponder];
    } else {
        [_cardCvv becomeFirstResponder];
    }
}

- (IBAction)donePressed:(id)sender {
    [self.view endEditing:YES];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    selectedTextField = textField;
    textField.inputAccessoryView = _navigationView;
}

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
