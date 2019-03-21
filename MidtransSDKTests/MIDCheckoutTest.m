//
//  MIDCheckoutTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 11/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDCheckoutTest : XCTestCase

@end

@implementation MIDCheckoutTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


- (void)testSuccessMinimalCheckout {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:[MIDTestHelper orderID]
                                                                      grossAmount:@20000
                                                                         currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx
                    options:nil
                 completion:^(MIDToken *_Nullable token, NSError *_Nullable error)
     {
         XCTAssertNotNil(token.token);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testDecimalGrossAmountFailedCheckout {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:[MIDTestHelper orderID]
                                                                      grossAmount:@20000.50
                                                                         currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx
                    options:nil
                 completion:^(MIDToken *_Nullable token, NSError *_Nullable error)
     {
         XCTAssertTrue(error.code == 400);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testZeroGrossAmountFailedCheckout {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:[MIDTestHelper orderID]
                                                                      grossAmount:@0
                                                                         currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx
                    options:nil
                 completion:^(MIDToken *_Nullable token, NSError *_Nullable error)
     {
         XCTAssertTrue(error.code == 400);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testFailedCheckoutWithNoOrderId {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:nil
                                                                      grossAmount:@20000.50
                                                                         currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx
                    options:nil
                 completion:^(MIDToken *_Nullable token, NSError *_Nullable error)
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
                 completion:^(MIDToken *_Nullable token, NSError *_Nullable error)
     {
         XCTAssertTrue(error.code == 400);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
