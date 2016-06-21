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
@interface VTPaymentDirectViewController ()
@property (strong, nonatomic) IBOutlet VTPaymentDirectView *view;

@end

@implementation VTPaymentDirectViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableString *mutableString = [NSMutableString string];
    [mutableString appendString:@"How can i Pay Via"];
    NSString *paymentName = @"";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOMARET]) {
        paymentName  = @"Indomaret";
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_KLIK_BCA]) {
        paymentName  = @"KlikBCA";
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER]) {
        paymentName  = @"BCA ATM";
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER]) {
        paymentName  = @"Mandiri ATM";
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER]) {
        paymentName  = @"Permata ATM";
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_OTHER_IDENTIFIER]) {
        paymentName  = @"Other Bank";
    }
    
    self.title = [NSString stringWithFormat: NSLocalizedString(@"Pay at %@",nil),[paymentName capitalizedString]];
    [self.view.howToPaymentButton setTitle:[NSString stringWithFormat:@"How can i Pay Via %@",[paymentName capitalizedString]] forState:UIControlStateNormal];
    self.view.totalAmountLabel.text = [[NSObject indonesianCurrencyFormatter] stringFromNumber:self.transactionDetails.grossAmount];
    self.view.orderIdLabel.text = self.transactionDetails.orderId;
    self.view.directPaymentTextField.text = self.customerDetails.email;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
