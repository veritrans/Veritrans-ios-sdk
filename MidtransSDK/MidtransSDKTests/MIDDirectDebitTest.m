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
}

- (void)testForDanamonOnline {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDDirectDebitCharge danamonOnlineWithToken:token completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result.redirectURL, @"danamon online test is error");
            [promise fulfill];
        }];
    }];
}

- (void)testForKlikbca {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        NSString *klikbcaUser = @"JUKI0303";
        [MIDDirectDebitCharge klikbcaWithToken:token
                                        userID:klikbcaUser
                                    completion:^(MIDKlikbcaResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.approvalCode, @"klikbca test is error");
             [promise fulfill];
         }];
    }];
}

- (void)testForMandiriClickpay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        NSString *cardNumber = @"4111111111111111";
        NSString *clickpayToken = @"000000";
        [MIDDirectDebitCharge mandiriClickpayWithToken:token
                                            cardNumber:cardNumber
                                         clickpayToken:clickpayToken
                                            completion:^(MIDClickpayResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.approvalCode, @"clickpay online test is error");
             [promise fulfill];
         }];
    }];
}

@end
