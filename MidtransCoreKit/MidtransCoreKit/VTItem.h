//
//  VTItem.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (item)
- (NSArray *)convertItemsToRequestData;
- (NSNumber *)amount;
@end

@interface VTItem : NSObject

@property(nonatomic, readonly) NSString* itemId;
@property(nonatomic, readonly) NSNumber *price;
@property(nonatomic, readonly) NSNumber *quantity;
@property(nonatomic, readonly) NSString* name;

+ (instancetype)itemWithId:(NSString *)itemId
                      name:(NSString *)name
                     price:(NSNumber *)price
                  quantity:(NSNumber *)quantity;

- (NSDictionary *)requestData;

@end
