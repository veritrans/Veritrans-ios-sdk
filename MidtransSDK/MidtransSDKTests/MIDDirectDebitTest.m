//
//  MIDDirectDebitTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 09/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MidtransSDK.h"

@interface MIDDirectDebitTest : XCTestCase

@end

@implementation MIDDirectDebitTest

- (void)setUp {
    [MIDClient configureClientKey:@"SB-Mid-client-txZHOj6jPP0_G8En"
                merchantServerURL:@"https://dev-mobile-store.herokuapp.com/"
                      environment:MIDEnvironmentSandbox];
}

- (void)getTokenWithCompletion:(void (^_Nullable) (NSString *_Nullable token, NSError *_Nullable error))completion {
    NSDate *date = [NSDate new];
    NSString *orderID = [NSString stringWithFormat:@"%f", date.timeIntervalSince1970];
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:orderID grossAmount:@1000];
    
    [MIDClient checkoutWith:trx options:nil completion:^(MIDToken * _Nullable token, NSError * _Nullable error) {
        NSString *_token = token.token;
        XCTAssertNotNil(_token);
        completion(_token, error);
    }];
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
