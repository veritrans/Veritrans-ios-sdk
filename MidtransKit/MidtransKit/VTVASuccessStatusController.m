//
//  VTVASuccessStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVASuccessStatusController.h"
#import "VTVAGuideController.h"
#import "VTPaymentStatusViewModel.h"
#import "VTButton.h"
#import "VTClassHelper.h"
#import "VTToast.h"

#import <QuartzCore/QuartzCore.h>

@interface VTVASuccessStatusController ()
@property (strong, nonatomic) IBOutlet UILabel *vaNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@property (nonatomic) VTVATransactionStatusViewModel *viewModel;
@end

@implementation VTVASuccessStatusController

- (instancetype)initWithViewModel:(VTVATransactionStatusViewModel *)viewModel {
    self = [[VTVASuccessStatusController alloc] initWithNibName:@"VTVASuccessStatusController" bundle:VTBundle];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setHidesBackButton:YES];

    _amountLabel.text = _viewModel.totalAmount;
    _orderIdLabel.text = _viewModel.orderId;
    _transactionTimeLabel.text = _viewModel.transactionTime;
    
    switch (_viewModel.vaType) {
        case VTVATypeBCA: {
            _vaNumberLabel.text = _viewModel.vaNumber;
            self.title = @"BCA Bank Transfer";
            break;
        } case VTVATypePermata: {
            _vaNumberLabel.text = _viewModel.vaNumber;
            self.title = @"Permata Bank Transfer";
            break;
        } case VTVATypeMandiri: {
        } case VTVATypeOther: {
            _vaNumberLabel.text = _viewModel.vaNumber;
            self.title = @"Other Bank Transfer";
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveVAPressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:_viewModel.vaNumber];
    [VTToast createToast:@"Copied to clipboard" duration:1.5 containerView:self.view];
}

- (IBAction)helpPressed:(UIButton *)sender {
    VTVAGuideController *vc = [VTVAGuideController controllerWithVAType:_viewModel.vaType];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{@"tr_result":_viewModel.transactionResult};
    [[NSNotificationCenter defaultCenter] postNotificationName:_TRANSACTION_SUCCESS object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
