//
//  VTConfirmPaymentController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTConfirmPaymentController.h"
#import "VTClassHelper.h"

@interface VTConfirmPaymentController ()
@property (strong, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *grossAmountLabel;

@property (nonatomic) NSString *cardNumber;
@property (nonatomic) NSNumber *grossAmount;

@property (nonatomic, copy) void (^callback)(NSInteger selectedIndex);

@end

@implementation VTConfirmPaymentController

+ (instancetype)controllerWithMaskedCardNumber:(NSString *)cardNumber grossAmount:(NSNumber *)amount callback:(void(^)(NSInteger selectedIndex))callback {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTConfirmPaymentController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTConfirmPaymentController"];
    vc.cardNumber = cardNumber;
    vc.grossAmount = amount;
    vc.callback = callback;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cardNumberLabel.text = [_cardNumber formattedCreditCardNumber];
    
    NSNumberFormatter *formatter = [NSObject numberFormatterWith:@"vt.number"];
    _grossAmountLabel.text = [@"Rp " stringByAppendingString:[formatter stringFromNumber:_grossAmount]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender {
    if (self.callback) {
        self.callback(sender.tag);
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
