//
//  VTIndomaretSuccessController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTIndomaretSuccessController.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <QuartzCore/QuartzCore.h>
#import "VTClassHelper.h"
#import "VTToast.h"

@interface VTIndomaretSuccessController ()
@property (nonatomic) VTPaymentStatusViewModel *statusModel;

@property (strong, nonatomic) IBOutlet UILabel *paymentCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;

@end

@implementation VTIndomaretSuccessController

- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails
                            itemDetails:(NSArray<VTItemDetail *> *)itemDetails
                     transactionDetails:(VTTransactionDetails *)transactionDetails
                      paymentMethodName:(VTPaymentListModel *)paymentMethod
                            statusModel:(VTPaymentStatusViewModel *)statusModel {
    
    self = [[VTIndomaretSuccessController alloc] initWithCustomerDetails:customerDetails
                                                             itemDetails:itemDetails
                                                      transactionDetails:transactionDetails
                                                       paymentMethodName:paymentMethod];
    if (self) {
        self.statusModel = statusModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    
    _amountLabel.text = _statusModel.totalAmount;
    _orderIdLabel.text = _statusModel.orderId;
    _transactionTimeLabel.text = _statusModel.transactionTime;
    _paymentCodeLabel.text = _statusModel.transactionResult.indomaretPaymentCode;
    
    self.title = [NSString stringWithFormat:UILocalizedString(@"payment.pay-at",nil), [VT_PAYMENT_INDOMARET capitalizedString]];
}

- (IBAction)copyCodePressed:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:_paymentCodeLabel.text];
    [VTToast createToast:@"Copied to clipboard" duration:1.5 containerView:self.view];
}

- (IBAction)helpPressed:(UIButton *)sender {
    [self showGuideViewController];
}

- (IBAction)finishPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
