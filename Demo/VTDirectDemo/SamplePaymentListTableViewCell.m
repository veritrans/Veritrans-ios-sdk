//
//  SamplePaymentListTableViewCell.m
//  VTDirectDemo
//
//  Created by Arie on 8/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "SamplePaymentListTableViewCell.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@implementation SamplePaymentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)configurePaymetnList:(VTPaymentListModel *)paymentList {
    self.paymentName.text = paymentList.title;
    self.paymentDescription.text = paymentList.internalBaseClassDescription;
    NSString *imagePath =[NSString stringWithFormat:@"%@",paymentList.internalBaseClassIdentifier];
    self.paymentLogo.image = [UIImage imageNamed:imagePath];
}
@end
