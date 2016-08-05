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
@property (nonatomic) VTItemDetail *item;
@end

@implementation VTItemViewModel

+ (instancetype)viewModelWithItem:(VTItemDetail *)item {
    VTItemViewModel *mv = [VTItemViewModel new];
    mv.item =  item;
    return mv;
}

- (NSString *)price {
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    return [formatter stringFromNumber:_item.price];
}
- (NSString *)quantity {
    return [NSString stringWithFormat:@"Quantity: %@", _item.quantity];
}
- (NSURL *)image {
    return nil;
}

@end
