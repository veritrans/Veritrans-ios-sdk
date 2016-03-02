//
//  VTCardDetailController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCardDetailController.h"
#import "VTClassHelper.h"
#import "VTTextField.h"
#import <MidtransCoreKit/VTCPaymentCreditCard.h>

@interface VTCardDetailController ()
@property (strong, nonatomic) IBOutlet VTTextField *cardName;
@property (strong, nonatomic) IBOutlet VTTextField *cardNumber;
@property (strong, nonatomic) IBOutlet VTTextField *cardExpiryDate;
@property (strong, nonatomic) IBOutlet VTTextField *cardCvv;
@property (strong, nonatomic) IBOutlet UISwitch *saveStateSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *creditCardLogo;
@property (strong, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardHolderLabel;
@property (strong, nonatomic) IBOutlet UILabel *expiryLabel;

@end

@implementation VTCardDetailController

+ (instancetype)newController {
    VTCardDetailController *vc = [[UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle] instantiateViewControllerWithIdentifier:@"VTCardDetailController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_cardExpiryDate addObserver:self forKeyPath:@"text" options:0 context:nil];
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
        _expiryLabel.text = _cardExpiryDate.text;
    }
}

- (IBAction)textFieldChanged:(id)sender {
    if ([sender isEqual:_cardName]) {
        _cardHolderLabel.text = _cardName.text;
    } else if ([sender isEqual:_cardNumber]) {
        [self updateCreditCardIconWithNumber:_cardNumber.text];
        _cardNumberLabel.text = _cardNumber.text;
    }
}

- (void)updateCreditCardIconWithNumber:(NSString *)number {
    VTCreditCardType type = [VTCreditCard typeWithNumber:number];
    switch (type) {
        case VTCreditCardTypeVisa:
            _creditCardLogo.image = [UIImage imageNamed:@"VisaDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
            break;
        case VTCreditCardTypeJCB:
            _creditCardLogo.image = [UIImage imageNamed:@"JCBDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
            break;
        case VTCreditCardTypeMasterCard:
            _creditCardLogo.image = [UIImage imageNamed:@"MasterCard" inBundle:VTBundle compatibleWithTraitCollection:nil];
            break;
        case VTCreditCardTypeUnknown:
            _creditCardLogo.image = nil;
            break;
    }
}

- (IBAction)cvvInfoPressed:(UIButton *)sender {
}

- (IBAction)paymentPressed:(UIButton *)sender {
//    NSInteger expMonth = [[[_cardExpiryDate.text componentsSeparatedByString:@"/"] firstObject] integerValue];
//    NSInteger expYear = [[[_cardExpiryDate.text componentsSeparatedByString:@"/"] lastObject] integerValue];
//    VTCreditCard *card = [VTCreditCard dataWithNumber:_cardNumber.text
//                                          expiryMonth:@(expMonth)
//                                           expiryYear:@(expYear)
//                                                saved:NO];
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
    } else if ([textField isEqual:_cardNumber] || [textField isEqual:_cardCvv]) {
        return [string isNumeric];
    } else {
        return YES;
    }
}

@end
