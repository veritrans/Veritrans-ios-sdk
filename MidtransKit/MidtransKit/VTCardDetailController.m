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
#import <MidtransCoreKit/VTCreditCard.h>

@interface VTCardDetailController ()
@property (strong, nonatomic) IBOutlet VTTextField *cardName;
@property (strong, nonatomic) IBOutlet VTTextField *cardNumber;
@property (strong, nonatomic) IBOutlet VTTextField *cardExpiryDate;
@property (strong, nonatomic) IBOutlet VTTextField *cardCvv;

@end

@implementation VTCardDetailController

+ (instancetype)newController {
    VTCardDetailController *vc = [[UIStoryboard storyboardWithName:@"Midtrans" bundle:[VTClassHelper kitBundle]] instantiateViewControllerWithIdentifier:@"VTCardDetailController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cardNumberChanged:(VTTextField *)sender {
    NSNumber *cardNumber = @([sender.text integerValue]);
    VTCreditCardType type = [VTCreditCard typeWithNumber:cardNumber];
    switch (type) {
        case VTCreditCardTypeVisa:
            NSLog(@"visa");
            break;
        case VTCreditCardTypeAmex:
            NSLog(@"amex");
            break;
        case VTCreditCardTypeDinersClub:
            NSLog(@"dc");
            break;
        case VTCreditCardTypeDiscover:
            NSLog(@"d");
            break;
        case VTCreditCardTypeJCB:
            NSLog(@"jcb");
            break;
        case VTCreditCardTypeMasterCard:
            NSLog(@"mastercard");
            break;
        case VTCreditCardTypeUnknown:
            NSLog(@"unknown");
            break;
    }
}

- (IBAction)paymentPressed:(UIButton *)sender {
    
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
