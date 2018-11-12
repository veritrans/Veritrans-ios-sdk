//
//  MIDItem.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface MIDItem : NSObject<MIDMappable>

@property (nonatomic) NSString *itemID;
@property (nonatomic, nonnull) NSNumber *price;
@property (nonatomic, nonnull) NSNumber *quantity;
@property (nonatomic, nonnull) NSString *name;
@property (nonatomic) NSString *brand;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *merchantName;

@end
