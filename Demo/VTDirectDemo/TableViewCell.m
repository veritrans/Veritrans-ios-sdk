//
//  TableViewCell.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/26/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation TableViewCell {
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_priceLabel;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIImageView *_imageView;
    
    NSNumberFormatter *_formatter;
}

- (void)awakeFromNib {
    // Initialization code
    
    _formatter = [NSNumberFormatter new];
    _formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    _formatter.locale = [NSLocale localeWithLocaleIdentifier:@"id_ID"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setItem:(VTItem *)item {
    _item = item;
    
    NSNumber *totalPrice = @(item.price.doubleValue * item.quantity.doubleValue);
    _priceLabel.text = [_formatter stringFromNumber:totalPrice];
    _nameLabel.text = item.name;
    _quantityLabel.text = item.quantity.stringValue;
    
    if (item.imageURL) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:item.imageURL]];
    }
}
@end
