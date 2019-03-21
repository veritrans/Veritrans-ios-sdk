//
//  MidtransItemCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 12/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransItemCell.h"
#import "VTClassHelper.h"
#import "MidtransUIThemeManager.h"

@interface MidtransItemCell()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *qtyLabel;
@end

@implementation MidtransItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0.f, self.bounds.size.width, 0.f, 0.f);
}

- (void)setItemInfo:(MIDItemInfo *)itemInfo {
    _itemInfo = itemInfo;
    
    double total = [itemInfo.price doubleValue] * itemInfo.quantity;
    self.priceLabel.text = [NSNumber numberWithDouble:total].formattedCurrencyNumber;
    self.nameLabel.text = itemInfo.name;
    self.qtyLabel.text = [NSString stringWithFormat:@"x%ld", (long)itemInfo.quantity];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

@end
