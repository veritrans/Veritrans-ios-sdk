//
//  MIDCardlessCreditTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 24/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDCardlessCreditTest : XCTestCase

@end

@implementation MIDCardlessCreditTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testSuccessAkulaku {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDCardlessCreditCharge akulakuWithToken:token completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertTrue(result.statusCode == 201, @"akulaku transaction status should be pending.");
            [promise fulfill];
        }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyTokenAkulaku {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDCardlessCreditCharge akulakuWithToken:nil completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue(error.code == 404, @"akulaku transaction should error 404 (empty token).");
        [promise fulfill];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
