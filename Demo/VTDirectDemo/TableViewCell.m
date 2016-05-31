//
//  TableViewCell.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/26/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"

#import <MidtransCoreKit/VTHelper.h>

@implementation TableViewCell {
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_priceLabel;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIImageView *_imageView;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setItem:(VTItemDetail *)item {
    _item = item;
    
    NSNumber *totalPrice = @(item.price.doubleValue * item.quantity.doubleValue);
    _priceLabel.text = [[NSObject indonesianCurrencyFormatter] stringFromNumber:totalPrice];
    _nameLabel.text = item.name;
    _quantityLabel.text = item.quantity.stringValue;
    
    [_imageView sd_setImageWithURL:item.imageURL];
}

@end
