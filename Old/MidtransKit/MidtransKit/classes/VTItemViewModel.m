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
@property (nonatomic) MidtransItemDetail *item;
@end

@implementation VTItemViewModel

+ (instancetype)viewModelWithItem:(MidtransItemDetail *)item {
    VTItemViewModel *mv = [VTItemViewModel new];
    mv.item =  item;
    return mv;
}

- (NSString *)price {
    return self.item.price.formattedCurrencyNumber;
}
- (NSString *)quantity {
    return [NSString stringWithFormat:@"Quantity: %@", self.item.quantity];
}
- (NSURL *)image {
    return nil;
}

@end
