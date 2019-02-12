//
//  SNPPostPaymentHeaderBillPay.h
//  MidtransKit
//
//  Created by Vanbungkring on 4/17/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPostPaymentHeader.h"

@interface SNPPostPaymentHeaderBillPay : SNPPostPaymentHeader
@property (weak, nonatomic) IBOutlet UITextField *companyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *companyCodeCopyButton;
@property (weak, nonatomic) IBOutlet UILabel *companyCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *vaNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ButtonCopyConstraintsBottomTextField;

@end
