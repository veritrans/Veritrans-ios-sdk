//
//  VTPaymentDirectViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentDirectViewController.h"
#import "VTPaymentDirectView.h"
#import "VTTextField.h"
#import "VTButton.h"
#import "VTVATransactionStatusViewModel.h"
#import "VTBillpaySuccessController.h"
#import "VTVASuccessStatusController.h"
#import "VTIndomaretSuccessController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@interface VTPaymentDirectViewController ()
@property (strong, nonatomic) IBOutlet VTPaymentDirectView *view;
@property (nonatomic) VTVAType paymentType;
@end

@implementation VTPaymentDirectViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *paymentName = @"";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOMARET]) {
        paymentName  = NSLocalizedString(@"Indomaret",nil);
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_KLIK_BCA_IDENTIFIER2]) {
        paymentName  =  NSLocalizedString(@"KlikBCA",nil);
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER]) {
        self.paymentType = VTVATypeBCA;
        paymentName  =  NSLocalizedString(@"BCA ATM",nil);
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER]) {
        self.paymentType = VTVATypeMandiri;
        paymentName  =  NSLocalizedString(@"Mandiri ATM",nil);
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER]) {
        self.paymentType = VTVATypePermata;
        paymentName  =  NSLocalizedString(@"Permata ATM",nil);
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_OTHER_IDENTIFIER]) {
        self.paymentType = VTVATypeOther;
        paymentName  =  NSLocalizedString(@"Other Bank",nil);
    }
    
    self.title = [NSString stringWithFormat: NSLocalizedString(@"%@",nil),[paymentName capitalizedString]];
    [self.view.howToPaymentButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"How can i Pay Via %@",nil),paymentName] forState:UIControlStateNormal];
    self.view.totalAmountLabel.text = [[NSObject indonesianCurrencyFormatter] stringFromNumber:self.transactionDetails.grossAmount];
    self.view.orderIdLabel.text = self.transactionDetails.orderId;
    self.view.directPaymentTextField.text = self.customerDetails.email;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)paymentGuideDidTapped:(id)sender {
    
}
- (IBAction)confirmPaymentDidTapped:(id)sender {
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_OTHER_IDENTIFIER]) {
        [self showLoadingHud];
        VTPaymentBankTransfer *paymentDetails = [[VTPaymentBankTransfer alloc] initWithBankTransferType:self.paymentType];
        self.customerDetails.email = self.view.directPaymentTextField.text;
        VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails transactionDetails:self.transactionDetails customerDetails:self.customerDetails itemDetails:self.itemDetails];
        [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
            [self hideLoadingHud];
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self handleTransactionSuccess:result];
            }
        }];
        
        
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_KLIK_BCA_IDENTIFIER2]){
        VTPaymentKlikBCA *paymentDetails = [[VTPaymentKlikBCA alloc] initWithKlikBCAUserId:self.view.directPaymentTextField.text];
        VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails transactionDetails:self.transactionDetails customerDetails:self.customerDetails itemDetails:self.itemDetails];
        [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
            [self hideLoadingHud];
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self handleTransactionSuccess:result];
            }
        }];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOMARET]) {
        VTPaymentCStore *paymentDetails = [[VTPaymentCStore alloc] initWithStoreName:@"Indomaret" message:@""];
        self.customerDetails.email = self.view.directPaymentTextField.text;
        VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails transactionDetails:self.transactionDetails customerDetails:self.customerDetails itemDetails:self.itemDetails];
        [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
            [self hideLoadingHud];
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self handleTransactionSuccess:result];
            }
        }];
    }
}

- (void)handleTransactionSuccess:(VTTransactionResult *)result {
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER] ||
        [self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_OTHER_IDENTIFIER]) {
        VTVATransactionStatusViewModel *vm = [[VTVATransactionStatusViewModel alloc] initWithTransactionResult:result vaType:self.paymentType];
        if (self.paymentType == VTVATypeMandiri) {
            VTBillpaySuccessController *vc = [[VTBillpaySuccessController alloc] initWithViewModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VTVASuccessStatusController *vc = [[VTVASuccessStatusController alloc] initWithViewModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOMARET]) {
        VTPaymentStatusViewModel *vm = [[VTPaymentStatusViewModel alloc] initWithTransactionResult:result];
        VTIndomaretSuccessController *vc = [[VTIndomaretSuccessController alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
