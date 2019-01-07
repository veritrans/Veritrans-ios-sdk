//
//  MIDBankTransferTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 05/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MidtransSDK.h"

@interface MIDBankTransferTest : XCTestCase

@end

@implementation MIDBankTransferTest

static NSString *_email = @"jukiginanjar@yahoo.com";

- (void)setUp {
    [MIDClient configureClientKey:@"SB-Mid-client-txZHOj6jPP0_G8En"
                merchantServerURL:@"https://dev-mobile-store.herokuapp.com/"
                      environment:MIDEnvironmentSandbox];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testForBCA {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDBankTransferCharge bcaWithToken:token email:_email completion:^(MIDBCABankTransferResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result.vaNumber, @"va bca test is error");
            [promise fulfill];
        }];
    }];
}

- (void)testForPermata {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDBankTransferCharge permataWithToken:token email:_email completion:^(MIDPermataBankTransferResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result.vaNumber, @"va permata test is error");
            [promise fulfill];
        }];
    }];
}

- (void)testForBNI {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDBankTransferCharge bniWithToken:token email:_email completion:^(MIDBNIBankTransferResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result.vaNumber, @"va bni test is error");
            [promise fulfill];
        }];
    }];
}

- (void)testForMandiri {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDBankTransferCharge mandiriWithToken:token email:_email completion:^(MIDMandiriBankTransferResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result.code, @"va mandiri test is error");
            [promise fulfill];
        }];
    }];
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

@end
