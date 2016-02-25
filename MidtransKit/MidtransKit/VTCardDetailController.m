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

@interface VTCardDetailController () <UITextFieldDelegate>
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

    _cardExpiryDate.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([string isNumeric] == NO) {
        return NO;
    }
    
    NSMutableString *changedString = textField.text.mutableCopy;
    [changedString replaceCharactersInRange:range withString:string];
    
    if ([changedString length] == 1 && [changedString integerValue] > 1) {
        textField.text = [NSString stringWithFormat:@"0%@/", changedString];
    } else if ([changedString length] == 2) {
        if ([changedString integerValue] < 13) {
            textField.text = changedString;
        }
    } else if ([changedString length] == 3) {
        if ([string length]) {
            [changedString insertString:@"/" atIndex:2];
        }
        textField.text = changedString;
    } else if ([changedString length] < 6) {
        textField.text = changedString;
    }
    return NO;
}

@end
