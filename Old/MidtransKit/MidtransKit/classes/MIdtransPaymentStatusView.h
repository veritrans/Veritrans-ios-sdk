//
//  MIdtransPaymentStatus.h
//  MidtransKit
//
//  Created by Arie on 10/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransTransactionResult;
@interface MIdtransPaymentStatusView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *paymentStatusIcon;
@property (weak, nonatomic) IBOutlet UIView *paymentStatusWrapperView;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusWrapperTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusWrapperContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusTotalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusOrderIdNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusTransactionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusPaymentTypeLabel;
- (void)configureWithTransactionResult:(MidtransTransactionResult *)result;
@end
