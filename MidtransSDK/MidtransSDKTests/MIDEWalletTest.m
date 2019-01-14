//
//  MIDEWalletTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 09/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDEWalletTest : XCTestCase

@end

@implementation MIDEWalletTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testForGopay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDEWalletCharge gopayWithToken:token
                              completion:^(MIDGopayResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.qrCodeURL, @"gopay test is error");
             [promise fulfill];
         }];
    }];
}

- (void)testForTCash {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDEWalletCharge tcashWithToken:token
                             phoneNumber:@"0811111111"
                              completion:^(MIDPaymentResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.orderID, @"T-Cash test is error");
             [promise fulfill];
         }];
    }];
}

- (void)testForMandiriEcash {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDEWalletCharge mandiriECashWithToken:token
                                     completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.redirectURL, @"Mandiri e-cash test is error");
             [promise fulfill];
         }];
    }];
}

@end
