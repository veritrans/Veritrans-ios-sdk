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
    [MIDClient configureClientKey:@"SB-Mid-client-txZHOj6jPP0_G8En"
                merchantServerURL:@"https://dev-mobile-store.herokuapp.com/"
                      environment:MIDEnvironmentSandbox];
}

- (void)getTokenWithCompletion:(void (^_Nullable) (NSString *_Nullable token, NSError *_Nullable error))completion {
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:[MIDTestHelper orderID]
                                                                      grossAmount:@20000
                                                                         currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx options:nil completion:^(MIDToken * _Nullable token, NSError * _Nullable error) {
        NSString *_token = token.token;
        XCTAssertNotNil(_token);
        completion(_token, error);
    }];
}

- (void)testForIndomaret {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDStoreCharge indomaretWithToken:token
                                completion:^(MIDIndomaretResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.paymentCode, @"indomaret test is error");
             [promise fulfill];
         }];
    }];
}

@end
