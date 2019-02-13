//
//  MidtransUIListCell.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransSDK.h"

@class MidtransPaymentListModel,MidtransPaymentRequestV2Response;
@interface MidtransUIListCell : UITableViewCell
@property (nonatomic) NSDictionary *item;
@property (weak, nonatomic) IBOutlet UIView *unavailableVIew;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodLogo;
@property (weak, nonatomic) IBOutlet UIView *tscSeparatorLineView;
@property (weak, nonatomic) IBOutlet UILabel *tscTextStatusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textStatusHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *promoNotificationView;

- (void)configureWithModel:(MidtransPaymentListModel *)model info:(MIDPaymentInfo *)info;

@end
