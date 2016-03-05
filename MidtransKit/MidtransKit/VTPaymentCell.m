//
//  VTPaymentCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentCell.h"
#import "VTClassHelper.h"

@implementation VTPaymentCell {
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIImageView *_iconView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPaymentItem:(NSDictionary *)paymentItem {
    _paymentItem = paymentItem;
    
    _nameLabel.text = paymentItem[@"name"];
    _iconView.image = [UIImage imageNamed:paymentItem[@"icon"] inBundle:VTBundle compatibleWithTraitCollection:nil];
}
@end
