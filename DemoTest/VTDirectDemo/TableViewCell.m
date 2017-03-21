//
//  TableViewCell.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/26/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"

#import <MidtransCoreKit/MidtransHelper.h>

@implementation TableViewCell {
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_priceLabel;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIImageView *_imageView;
}

- (void)setItem:(MidtransItemDetail *)item {
    _item = item;
    
    NSNumber *totalPrice = @(item.price.doubleValue * item.quantity.doubleValue);
    _priceLabel.text = [[NSObject indonesianCurrencyFormatter] stringFromNumber:totalPrice];
    _nameLabel.text = item.name;
    _quantityLabel.text = item.quantity.stringValue;
    
    [_imageView sd_setImageWithURL:item.imageURL];
}
- (void)configureSampleWithTitle:(NSString *)title {
  _nameLabel.text = title;
}
@end
