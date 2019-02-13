//
//  MIDItemsInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 13/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"
#import "MIDModelEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDItemInfo : NSObject <MIDMappable>

@property (nonatomic) NSString *itemID;
@property (nonatomic, nonnull) NSNumber *price;
@property (nonatomic) NSInteger quantity;
@property (nonatomic, nonnull) NSString *name;

@end

NS_ASSUME_NONNULL_END
