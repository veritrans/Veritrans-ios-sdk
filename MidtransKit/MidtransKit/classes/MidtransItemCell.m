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

- (void)setItemDetail:(MidtransItemDetail *)itemDetail {
    _itemDetail = itemDetail;
    double total = [itemDetail.price doubleValue] * [itemDetail.quantity doubleValue];
    self.priceLabel.text = [NSNumber numberWithDouble:total].formattedCurrencyNumber;
    self.nameLabel.text = itemDetail.name;
    self.qtyLabel.text = [NSString stringWithFormat:@"x%@", itemDetail.quantity];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

@end
