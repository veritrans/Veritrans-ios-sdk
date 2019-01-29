//
//  MIDStoreTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 09/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDStoreTest : XCTestCase

@end

@implementation MIDStoreTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testForIndomaret {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString *_Nullable token, NSError *_Nullable error) {
        [MIDStoreCharge indomaretWithToken:token
                                completion:^(MIDIndomaretResult *_Nullable result, NSError *_Nullable error)
         {
             XCTAssertNotNil(result.paymentCode, @"indomaret test is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyTokenIndomaret {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDStoreCharge indomaretWithToken:nil
                            completion:^(MIDIndomaretResult *_Nullable result, NSError *_Nullable error)
     {
         XCTAssertTrue(error.code == 404, @"indomaret transaction should be error 404");
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
