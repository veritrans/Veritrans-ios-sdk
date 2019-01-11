//
//  MIDClientTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDGetPaymentTest : XCTestCase

@end

@implementation MIDGetPaymentTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testFetchPayment {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:[MIDTestHelper orderID]
                                                                      grossAmount:@20000
                                                                         currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx
                    options:nil
                 completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
     {
         [MIDClient getPaymentInfoWithToken:token.token
                                 completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error)
          {
              XCTAssertNil(error, @"Request create token error.");
              [promise fulfill];
          }];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testTokenFailedFetchPayment {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDClient getPaymentInfoWithToken:@"random_failed_token"
                            completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
