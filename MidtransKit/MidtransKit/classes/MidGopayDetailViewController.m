//
//  MidGopayDetailViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 11/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#import "MidGopayDetailViewController.h"
#import "MIDGopayDetailView.h"
#import "VTClassHelper.h"
@interface MidGopayDetailViewController ()

@property (strong, nonatomic) IBOutlet MIDGopayDetailView *view;
@end

@implementation MidGopayDetailViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pay using GO-PAY";
    
    if (IPAD) {
        self.view.topWrapperView.hidden = YES;
        self.view.qrcodeWrapperView.hidden = NO;
        self.view.finishPaymentHeightConstraints.constant = 0.0f;
        self.view.bottomAmountConstraints.constant = 0.0f;
        [self.view layoutIfNeeded];
        
    } else {
        self.view.topWrapperView.hidden = YES;
        self.view.qrcodeWrapperView.hidden = NO;
    }
    
    self.view.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)qrcodeReloadDidTapped:(id)sender {
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
