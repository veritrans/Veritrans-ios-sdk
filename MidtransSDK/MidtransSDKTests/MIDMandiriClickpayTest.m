//
//  MIDMandiriClickpayTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 11/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDMandiriClickpayTest : XCTestCase

@end

@implementation MIDMandiriClickpayTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testSuccessMandiriClickpay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        NSString *cardNumber = @"4111111111111111";
        NSString *clickpayToken = @"000000";
        [MIDDirectDebitCharge mandiriClickpayWithToken:token
                                            cardNumber:cardNumber
                                         clickpayToken:clickpayToken
                                            completion:^(MIDClickpayResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertTrue([result.transactionStatus isEqualToString:@"settlement"]);
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testDenyMandiriClickpay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        NSString *cardNumber = @"4111111111111111";
        NSString *clickpayToken = @"111111";
        [MIDDirectDebitCharge mandiriClickpayWithToken:token
                                            cardNumber:cardNumber
                                         clickpayToken:clickpayToken
                                            completion:^(MIDClickpayResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertTrue([result.transactionStatus isEqualToString:@"deny"]);
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyNumberMandiriClickpay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        NSString *cardNumber = @"";
        NSString *clickpayToken = @"000000";
        [MIDDirectDebitCharge mandiriClickpayWithToken:token
                                            cardNumber:cardNumber
                                         clickpayToken:clickpayToken
                                            completion:^(MIDClickpayResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertTrue(error.code == 400);
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyClickpayTokenMandiriClickpay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        NSString *cardNumber = @"4111111111111111";
        NSString *clickpayToken = @"";
        [MIDDirectDebitCharge mandiriClickpayWithToken:token
                                            cardNumber:cardNumber
                                         clickpayToken:clickpayToken
                                            completion:^(MIDClickpayResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertTrue(error.code == 400);
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptySnapTokenMandiriClickpay {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    NSString *cardNumber = @"4111111111111111";
    NSString *clickpayToken = @"000000";
    [MIDDirectDebitCharge mandiriClickpayWithToken:nil
                                        cardNumber:cardNumber
                                     clickpayToken:clickpayToken
                                        completion:^(MIDClickpayResult * _Nullable result, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
