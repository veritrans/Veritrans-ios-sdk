//
//  VTMandiriECashController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMandiriECashController.h"
#import "VTClassHelper.h"
#import "VTPaymentGuideController.h"
#import "UIViewController+HeaderSubtitle.h"
#import "VTHudView.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTMandiriECashController ()
@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (nonatomic) VTHudView *hudView;
@end

@implementation VTMandiriECashController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setHeaderWithTitle:@"Mandiri e-Cash" subTitle:@"Payment Instructions"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTPaymentGuideController *guide = [storyboard instantiateViewControllerWithIdentifier:@"VTPaymentGuideController"];
    NSString *path = [VTBundle pathForResource:@"ecashGuide" ofType:@"plist"];
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
    
    VTPaymentMandiriECash *paymentDetails = [[VTPaymentMandiriECash alloc] initWithDescription:@"mandiri ecash description"];
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails
                                                            transactionDetails:self.transactionDetails
                                                               customerDetails:self.customerDetails
                                                                   itemDetails:self.itemDetails];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        [_hudView hide];
        
        if (error) {
            [self handleTransactionError:error];
        } else {
            
        }
    }];
}
@end
