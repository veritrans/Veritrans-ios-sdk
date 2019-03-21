//
//  MIDArrayHelper.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 13/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIDArrayHelper : NSObject

@end

NS_ASSUME_NONNULL_END

@interface NSArray (utils)

- (NSArray *)map:(id (^)(id obj))block;

- (NSArray *)filter:(BOOL (^)(id obj))block;

- (id)reduce:(id)initial
       block:(id (^)(id obj1, id obj2))block;

- (NSArray *)flatMap:(id (^)(id obj))block;

@end
