//
//  MIDItem.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"

@interface MIDItem : NSObject<MIDCheckoutable>

@property (nonatomic) NSString *itemID;
@property (nonatomic, nonnull) NSNumber *price;
@property (nonatomic) NSInteger quantity;
@property (nonatomic, nonnull) NSString *name;
@property (nonatomic) NSString *brand;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *merchantName;

/**
 @param itemID Item ID
 @param price Price of the item
 NOTE: Don’t add decimal
 @param quantity Quantity of the item
 @param name Name of the item
 @param brand Brand of the item
 @param category Category of the item
 @param merchantName Merchant selling the item
 */
- (instancetype _Nonnull)initWithID:(NSString *)itemID
                              price:(NSNumber * _Nonnull)price
                           quantity:(NSInteger)quantity
                               name:(NSString * _Nonnull)name
                              brand:(NSString *)brand
                           category:(NSString *)category
                       merchantName:(NSString *)merchantName;

@end
