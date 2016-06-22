//
//  VTVASuccessStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/20/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVASuccessStatusController.h"
#import "VTPaymentStatusViewModel.h"
#import "VTButton.h"
#import "VTClassHelper.h"
#import "VTToast.h"
#import "VTMultiGuideController.h"

#import <QuartzCore/QuartzCore.h>

@interface VTVASuccessStatusController ()
@property (strong, nonatomic) IBOutlet UILabel *vaNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@property (nonatomic) VTVATransactionStatusViewModel *statusModel;
@end

@implementation VTVASuccessStatusController

- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray<VTItemDetail *> *)itemDetails transactionDetails:(VTTransactionDetails *)transactionDetails paymentMethodName:(VTPaymentListModel *)paymentMethod statusModel:(VTVATransactionStatusViewModel *)statusModel {
    self = [[VTVASuccessStatusController alloc] initWithCustomerDetails:customerDetails itemDetails:itemDetails transactionDetails:transactionDetails paymentMethodName:paymentMethod];
    if (self) {
        self.statusModel = statusModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setHidesBackButton:YES];
    
    _amountLabel.text = _statusModel.totalAmount;
    _orderIdLabel.text = _statusModel.orderId;
    _transactionTimeLabel.text = _statusModel.transactionTime;
    
    switch (_statusModel.vaType) {
        case VTVATypeBCA: {
            _vaNumberLabel.text = _statusModel.vaNumber;
            self.title = NSLocalizedString(@"BCA Bank Transfer",nil);
            break;
        } case VTVATypePermata: {
            _vaNumberLabel.text = _statusModel.vaNumber;
            self.title = NSLocalizedString(@"Permata Bank Transfer",nil);
            break;
        } case VTVATypeMandiri: {
        } case VTVATypeOther: {
            _vaNumberLabel.text = _statusModel.vaNumber;
            self.title = NSLocalizedString(@"Other Bank Transfer",nil);
            break;
        }
    }
}

- (IBAction)saveVAPressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:_statusModel.vaNumber];
    [VTToast createToast:NSLocalizedString(@"Copied to clipboard",nil) duration:1.5 containerView:self.view];
}

- (IBAction)helpPressed:(UIButton *)sender {
    [self showGuideViewController];
}

- (IBAction)finishPressed:(UIButton *)sender {
    NSDictionary *userInfo = @{@"tr_result":_statusModel.transactionResult};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
