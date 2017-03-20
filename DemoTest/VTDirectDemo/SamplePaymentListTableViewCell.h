//
//  SamplePaymentListTableViewCell.h
//  VTDirectDemo
//
//  Created by Arie on 8/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransPaymentListModel;
@interface SamplePaymentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *paymentLogo;
@property (weak, nonatomic) IBOutlet UILabel *paymentName;
@property (weak, nonatomic) IBOutlet UILabel *paymentDescription;
- (void)configurePaymetnList:(MidtransPaymentListModel *)paymentList;
- (void)configureBankTransafer:(NSString *)bankTransfer;
@end
