//
//  MidtransPaymentStatusViewController.m
//  MidtransKit
//
//  Created by Arie on 10/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentStatusViewController.h"
#import "MIdtransPaymentStatusView.h"
#import "VTClassHelper.h"
#import "VTKITConstant.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@interface MidtransPaymentStatusViewController ()
@property (strong, nonatomic) IBOutlet MIdtransPaymentStatusView *view;
@property (nonnull,strong) MidtransTransactionResult *result;
@end

@implementation MidtransPaymentStatusViewController
@dynamic view;

- (instancetype)initWithTransactionResult:(MidtransTransactionResult *)result {
    self = [super initWithNibName:@"MidtransPaymentStatusViewController" bundle:VTBundle];
    if (self) {
        self.result = result;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [VTClassHelper getTranslationFromAppBundleForString:@"payment.pending"];
    [self showDismissButton:YES];
    [self showBackButton:NO];
    [self.view configureWithTransactionResult:self.result];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FinishButtonDidTapped:(id)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
