//
//  VTHelper.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTHelper : NSObject
+ (id)nullifyIfNil:(id)object;
@end

@interface NSArray (item)
- (NSArray *)itemsRequestData;
- (NSNumber *)itemsPriceAmount;
@end

@interface NSString (random)
+ (NSString *)randomWithLength:(NSUInteger)length;
@end