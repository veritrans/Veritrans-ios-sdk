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
    
    [self getTokenWithCompletion:^(NSString *_Nullable token, NSError *_Nullable error) {
        [MIDEWalletCharge gopayWithToken:token
                              completion:^(MIDGopayResult *_Nullable result, NSError *_Nullable error)
         {
             XCTAssertNotNil(result.qrCodeURL, @"gopay test is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testForMandiriEcash {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString *_Nullable token, NSError *_Nullable error) {
        [MIDEWalletCharge mandiriECashWithToken:token
                                     completion:^(MIDWebPaymentResult *_Nullable result, NSError *_Nullable error)
         {
             XCTAssertNotNil(result.redirectURL, @"Mandiri e-cash test is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyTokenGopay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDEWalletCharge gopayWithToken:nil
                          completion:^(MIDGopayResult *_Nullable result, NSError *_Nullable error)
     {
         XCTAssertTrue(error.code == 404, @"error should be 404");
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyTokenMandiriEcash {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDEWalletCharge mandiriECashWithToken:nil
                                 completion:^(MIDWebPaymentResult *_Nullable result, NSError *_Nullable error)
     {
         XCTAssertTrue(error.code == 404, @"error should be 404");
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
