//
//  VTCartCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCartCell.h"
#import "VTClassHelper.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation VTCartCell {
    IBOutlet UILabel *_priceLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UIImageView *_imageView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(VTItem *)item {
    _item = item;
    
    VTItemViewModel *vm = [VTItemViewModel viewModelWithItem:item];
    _priceLabel.text = vm.price;
    _quantityLabel.text = vm.quantity;
    
    if (vm.image) {
        [_imageView sd_setImageWithURL:vm.image];
    }
}

@end
