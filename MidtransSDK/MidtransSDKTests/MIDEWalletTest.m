//
//  MIDEWalletTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 09/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MidtransSDK.h"

@interface MIDEWalletTest : XCTestCase

@end

@implementation MIDEWalletTest

- (void)setUp {
    [MIDClient configureClientKey:@"SB-Mid-client-txZHOj6jPP0_G8En"
                merchantServerURL:@"https://dev-mobile-store.herokuapp.com/"
                      environment:MIDEnvironmentSandbox];
}

- (void)getTokenWithCompletion:(void (^_Nullable) (NSString *_Nullable token, NSError *_Nullable error))completion {
    NSDate *date = [NSDate new];
    NSString *orderID = [NSString stringWithFormat:@"%f", date.timeIntervalSince1970];
    MIDCheckoutTransaction *trx = [MIDCheckoutTransaction modelWithOrderID:orderID grossAmount:@1000 currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx options:nil completion:^(MIDToken * _Nullable token, NSError * _Nullable error) {
        NSString *_token = token.token;
        XCTAssertNotNil(_token);
        completion(_token, error);
    }];
    
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
