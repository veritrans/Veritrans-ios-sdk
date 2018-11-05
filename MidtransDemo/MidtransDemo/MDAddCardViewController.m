//
//  MDAddCardViewController.m
//  MidtransDemo
//
//  Created by Vanbungkring on 5/5/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDAddCardViewController.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <ACFloatingTextfield_Objc/ACFloatingTextField.h>
#import <CHRTextFieldFormatter/CHRTextFieldFormatter.h>
#import <CHRTextFieldFormatter/CHRCardNumberMask.h>

@interface MDAddCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet ACFloatingTextField *cardNumberTextFIeld;
@property (nonatomic, strong) CHRTextFieldFormatter *cardNumberFormatter;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *expiryDate;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *cvv;

@end

@implementation MDAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add New Card";
    self.cardNumberFormatter = [[CHRTextFieldFormatter alloc] initWithTextField:self.cardNumberTextFIeld mask:[CHRCardNumberMask new]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.cardNumberTextFIeld) {
        // Prevent crashing undo bug – see note below.
        [self.cardNumberFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 19;
    } else if ([textField isEqual:self.cvv]) {
        return [textField filterCvvNumber:string
                                    range:range
                           withCardNumber:self.cvv.text];
    } else if ([textField isEqual:self.expiryDate]) {
       return [textField filterCreditCardExpiryDate:string range:range];
    } else {
        return YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSError *error;
    if ([textField isEqual:self.cardNumberTextFIeld]) {
        [textField.text isValidCreditCardNumber:&error];
    }
    if ([textField isEqual:self.expiryDate]) {
        [textField.text isValidExpiryDate:&error];
    }
    else if ([textField isEqual:self.cvv]) {
        [textField.text isValidCVVWithCreditCardNumber:self.cvv.text error:&error];
    }
    //show warning if error
    if (error) {
        [self showError:textField withError:error];
    }
}
- (void)showError:(UITextField *)textfield withError:(NSError *)err{
    if (textfield == self.cardNumberTextFIeld) {
        self.cardNumberTextFIeld.errorText = @"Card Number invalid";
        [self.cardNumberTextFIeld showError];
    }
}
- (IBAction)saveCardButtonDidtapped:(id)sender {

    NSString *clientkey = @"your client key";
    NSString *merchantServer = @"your merchant server url";
    [[MidtransNetworkLogger shared] startLogging];
    [CONFIG setClientKey:clientkey
             environment:MidtransServerEnvironmentSandbox
       merchantServerURL:merchantServer];
    
    JGProgressHUD *hud =  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    hud.textLabel.text = @"Loading";
    [hud showInView:self.navigationController.view];
    NSArray *data = [self.expiryDate.text componentsSeparatedByString:@"/"];
    NSString *expMonth = [data[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *expYear = [NSString stringWithFormat:@"%ld",[data[1] integerValue]+2000];
   
    MidtransCreditCard *creditCard = [[MidtransCreditCard alloc] initWithNumber: [self.cardNumberTextFIeld.text stringByReplacingOccurrencesOfString:@" " withString:@""]  expiryMonth:expMonth expiryYear:expYear cvv:self.cvv.text];
    [[MidtransClient shared] registerCreditCard:creditCard completion:^(MidtransMaskedCreditCard * _Nullable maskedCreditCard, NSError * _Nullable error) {
        [hud dismiss];
        if (!error) {
            [self saveCreditCardObject:maskedCreditCard];
        }
        else {
            NSLog(@"error-->%@",error.description);
        }
        
    }];
    
    
}

- (void)saveCreditCardObject:(MidtransMaskedCreditCard *)creditCardObject {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfRawCard = [userDefaults objectForKey:@"SAVED_CARD"];
    NSMutableArray *mutableDataArray =[NSMutableArray arrayWithArray:arrayOfRawCard];
    [mutableDataArray addObject:[creditCardObject dictionaryValue]];
    [userDefaults setObject:mutableDataArray forKey:@"SAVED_CARD"];
    [userDefaults objectForKey:@"SAVED_CARD"];
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
