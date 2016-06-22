//
//  VTVAController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVAController.h"
#import "VTTextField.h"
#import "VTVAGuideController.h"
#import "VTKeyboardAccessoryView.h"
#import "VTHudView.h"
#import "VTVASuccessStatusController.h"
#import "VTButton.h"
#import "VTBillpaySuccessController.h"
#import <MidtransCoreKit/VTPaymentBankTransfer.h>
#import <MidtransCoreKit/VTTransaction.h>
#import <MidtransCoreKit/VTMerchantClient.h>

@interface VTVAController ()
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet VTTextField *emailTextField;
@property (strong, nonatomic) IBOutlet VTButton *helpButton;
@property (nonatomic) VTKeyboardAccessoryView *keyboardAccessoryView;
@property (nonatomic, assign) VTVAType vaType;
@property (nonatomic) VTHudView *hudView;

@end

@implementation VTVAController

- (instancetype)initWithVAType:(VTVAType)type customerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray<VTItemDetail*>*)itemDetails transactionDetails:(VTTransactionDetails*)transactionDetails {
    if (self = [super initWithCustomerDetails:customerDetails itemDetails:itemDetails transactionDetails:transactionDetails paymentMethodName:nil]) {
        self.vaType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _hudView = [[VTHudView alloc] init];
    
    _keyboardAccessoryView = [[VTKeyboardAccessoryView alloc] initWithFrame:CGRectZero fields:@[_emailTextField]];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    switch (self.vaType) {
        case VTVATypeBCA: {
            self.title = UILocalizedString(@"BCA ATM", nil);
            [_helpButton setTitle:[NSString stringWithFormat:UILocalizedString(@"payment.va.help-button-title", nil), @"BCA"] forState:UIControlStateNormal];
            break;
        } case VTVATypeMandiri: {
            self.title =  UILocalizedString(@"Mandiri ATM",nil);
            [_helpButton setTitle:[NSString stringWithFormat:UILocalizedString(@"payment.va.help-button-title", nil), @"Mandiri"] forState:UIControlStateNormal];
            break;
        } case VTVATypePermata: {
            self.title = UILocalizedString(@"Permata ATM",nil);
            [_helpButton setTitle:[NSString stringWithFormat:UILocalizedString(@"payment.va.help-button-title", nil), @"Permata"] forState:UIControlStateNormal];
            break;
        } case VTVATypeOther: {
            self.title = UILocalizedString(@"Other Bank",nil);
            [_helpButton setTitle:[NSString stringWithFormat:UILocalizedString(@"payment.va.help-button-title", nil), @"Other"] forState:UIControlStateNormal];
            break;
        }
    }
    
    _emailTextField.text = self.customerDetails.email;
    
    self.amountLabel.text = [[NSObject indonesianCurrencyFormatter] stringFromNumber:self.transactionDetails.grossAmount];
    self.orderIdLabel.text = self.transactionDetails.orderId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)helpPressed:(UIButton *)sender {
    VTVAGuideController *vc = [VTVAGuideController controllerWithVAType:_vaType];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)paymentPressed:(UIButton *)sender {
    [_hudView showOnView:self.navigationController.view];
    
    VTPaymentBankTransfer *paymentDetails = [[VTPaymentBankTransfer alloc] initWithBankTransferType:self.vaType];
    
    self.customerDetails.email = _emailTextField.text;
    
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

- (void)handleTransactionSuccess:(VTTransactionResult *)result {
    VTVATransactionStatusViewModel *vm = [[VTVATransactionStatusViewModel alloc] initWithTransactionResult:result vaType:_vaType];
    if (_vaType == VTVATypeMandiri) {
        VTBillpaySuccessController *vc = [[VTBillpaySuccessController alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VTVASuccessStatusController *vc = [[VTVASuccessStatusController alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
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
