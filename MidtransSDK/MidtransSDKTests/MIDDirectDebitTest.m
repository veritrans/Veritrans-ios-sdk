//
//  MIDDirectDebitTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 09/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDDirectDebitTest : XCTestCase

@end

@implementation MIDDirectDebitTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testForBCAKlikPay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDDirectDebitCharge bcaKlikPayWithToken:token
                                       completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.redirectURL, @"bca klikpay test is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyTokenBCAKlikPay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDDirectDebitCharge bcaKlikPayWithToken:nil completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue(error.code == 404, @"error code should be 404");
        [promise fulfill];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}


- (void)testForCIMBClicks {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDDirectDebitCharge cimbClicksWithToken:token
                                       completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.redirectURL, @"cimb clicks test is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyTokenCIMBClicks {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDDirectDebitCharge cimbClicksWithToken:nil completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue(error.code == 404, @"error code should be 404");
        [promise fulfill];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testForBRIEpay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDDirectDebitCharge briEpayWithToken:token
                                    completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.redirectURL, @"bri epay test is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyTokenBRIEpay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDDirectDebitCharge briEpayWithToken:nil completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue(error.code == 404, @"error code should be 404");
        [promise fulfill];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testForDanamonOnline {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDDirectDebitCharge danamonOnlineWithToken:token completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result.redirectURL, @"danamon online test is error");
            [promise fulfill];
        }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyTokenDanamonOnline {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDDirectDebitCharge danamonOnlineWithToken:nil completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue(error.code == 404, @"error code should be 404");
        [promise fulfill];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
