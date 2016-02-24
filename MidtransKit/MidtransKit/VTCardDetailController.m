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

- (IBAction)paymentPressed:(UIButton *)sender {
    if ([_cardCvv.warning length]) {
        _cardCvv.warning = nil;
    } else {
        _cardCvv.warning = @"Wrong input";
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

@end
