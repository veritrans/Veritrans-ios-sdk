//
//  MIDClientTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDClientTest : XCTestCase

@end

@implementation MIDClientTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


- (void)testSuccessMinimalCheckout {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDCheckoutTransaction *trx = [MIDCheckoutTransaction modelWithOrderID:[MIDTestHelper orderID]
                                                               grossAmount:@20000
                                                                  currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx
                    options:nil
                 completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
     {
         XCTAssertNotNil(token.token);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testDecimalGrossAmountFailedCheckout {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDCheckoutTransaction *trx = [MIDCheckoutTransaction modelWithOrderID:[MIDTestHelper orderID]
                                                               grossAmount:@20000.50
                                                                  currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx
                    options:nil
                 completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 400);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testZeroGrossAmountFailedCheckout {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    NSString *orderID = [MIDTestHelper orderID];
    MIDCheckoutTransaction *trx = [MIDCheckoutTransaction modelWithOrderID:orderID
                                                               grossAmount:@0
                                                                  currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx
                    options:nil
                 completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 400);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testFetchPayment {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDCheckoutTransaction *trx = [MIDCheckoutTransaction modelWithOrderID:[MIDTestHelper orderID]
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

- (void)testFailedCheckoutWithNoOrderId {
    XCTestExpectation *promise = [XCTestExpectation new];
    MIDCheckoutTransaction *trx = [MIDCheckoutTransaction modelWithOrderID:nil
                                                               grossAmount:@20000
                                                                  currency:MIDCurrencyIDR];
    [MIDClient checkoutWith:trx
                    options:nil
                 completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 400);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testFailedCheckoutWithNoTransactionParameters {
    XCTestExpectation *promise = [XCTestExpectation new];
    [MIDClient checkoutWith:nil
                    options:nil
                 completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 400);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
