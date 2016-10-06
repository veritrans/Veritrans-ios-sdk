//
//  MidtransUIListCell.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VTPaymentListModel;
@interface MidtransUIListCell : UITableViewCell
@property (nonatomic) NSDictionary *item;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodLogo;
- (void)configurePaymetnList:(VTPaymentListModel *)paymentList;
@end
