//
//  MIDTestHelpers.h
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 07/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "MIDTransSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDTestHelper : NSObject

+ (NSString *)orderID;
+ (void)setup;
+ (NSNumber *)grossAmount;

@end

@interface XCTestCase (helper)

- (void)getTokenWithCompletion:(void (^_Nullable) (NSString *_Nullable token, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
