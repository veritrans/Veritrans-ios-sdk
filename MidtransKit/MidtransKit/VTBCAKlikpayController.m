//
//  VTBCAKlikpayController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTBCAKlikpayController.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"
#import "UIViewController+HeaderSubtitle.h"
#import "VTHudView.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTBCAKlikpayController ()
@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (nonatomic) VTHudView *hudView;
@end

@implementation VTBCAKlikpayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setHeaderWithTitle:@"BCA KlikPay" subTitle:@"Payment Instructions"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTPaymentGuideController *guide = [storyboard instantiateViewControllerWithIdentifier:@"VTPaymentGuideController"];
    NSString *path = [VTBundle pathForResource:@"klikpayGuide" ofType:@"plist"];
    guide.guides = [NSArray arrayWithContentsOfFile:path];
    [self addSubViewController:guide toView:_helpView];
    
    _hudView = [[VTHudView alloc] init];
    
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    self.amountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
    self.orderIdLabel.text = self.transactionDetails.orderId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    [_hudView showOnView:self.navigationController.view];
    
    VTPaymentBCAKlikpay *paymentDetails = [[VTPaymentBCAKlikpay alloc] initWithDescription:@"klikpay bca description"];
    
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails transactionDetails:self.transactionDetails customerDetails:self.customerDetails itemDetails:self.itemDetails];
    
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        [_hudView hide];
        
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

@end
