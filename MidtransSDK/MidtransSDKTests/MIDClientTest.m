//
//  MIDClientTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTransSDK.h"

@interface MIDClientTest : XCTestCase

@end

@implementation MIDClientTest

- (void)setUp {
    [MIDClient configureClientKey:@"SB-Mid-client-txZHOj6jPP0_G8En"
                merchantServerURL:@"https://dev-mobile-store.herokuapp.com/"
                      environment:MIDEnvironmentSandbox];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testFetchPayment {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    NSDate *date = [NSDate new];
    NSString *orderID = [NSString stringWithFormat:@"%f", date.timeIntervalSince1970];
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:orderID grossAmount:@1000];
    
    [MIDClient checkoutWith:trx options:nil completion:^(MIDToken * _Nullable token, NSError * _Nullable error) {
        NSString *_token = token.token;
        XCTAssertNotNil(_token);
        
        [MIDClient getPaymentInfoWithToken:_token completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error) {
            XCTAssertNil(error, @"Request create token error.");
            [promise fulfill];
        }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
