//
//  VTItemViewModel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTItemViewModel.h"
#import "VTClassHelper.h"

@interface VTItemViewModel()
@property (nonatomic) VTItem *item;
@end

@implementation VTItemViewModel

+ (instancetype)viewModelWithItem:(VTItem *)item {
    VTItemViewModel *mv = [VTItemViewModel new];
    mv.item =  item;
    return mv;
}

- (NSString *)price {
    NSNumberFormatter *formatter = [NSNumberFormatter numberFormatterWith:@"vt.number"];
    return [NSString stringWithFormat:@"Rp %@", [formatter stringFromNumber:_item.price]];
}
- (NSString *)quantity {
    return [NSString stringWithFormat:@"Quantity: %@", _item.quantity];
}
- (NSURL *)image {
    return [NSURL URLWithString:_item.imageURL];
}

+ (NSString *)totalPriceOfItems:(NSArray *)items {
    NSNumber *price = [items itemsPriceAmount];
    NSNumberFormatter *formatter = [NSNumberFormatter numberFormatterWith:@"vt.number"];
    return [NSString stringWithFormat:@"Rp %@", [formatter stringFromNumber:price]];
}

@end
