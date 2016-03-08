//
//  VTListCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTListCell.h"
#import "VTClassHelper.h"

@implementation VTListCell {
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

- (void)setItem:(NSDictionary *)item {
    _item = item;
    
    _nameLabel.text = item[@"name"];
    _iconView.image = [UIImage imageNamed:item[@"icon"] inBundle:VTBundle compatibleWithTraitCollection:nil];
}
@end
