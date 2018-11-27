//
//  MIDClientTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDClient.h"
#import "MIDCheckoutRequest"
@interface MIDClientTest : XCTestCase

@end

@implementation MIDClientTest

- (void)setUp {
    [[MIDClient shared] configureClientKey:@"SB-Mid-client-txZHOj6jPP0_G8En"
                         merchantServerURL:@"https://dev-mobile-store.herokuapp.com/"
                               environment:MIDEnvironmentSandbox];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testFetchPaymentSuccess {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    NSDate *date = [NSDate new];
    NSString *orderID = [NSString stringWithFormat:@"%f", date.timeIntervalSince1970];
    MIDTransaction *trans = [MIDTransaction modelWithOrderID:orderID grossAmount:@1000];
    MIDCheckoutRequest *req = [[MIDCheckoutRequest alloc] initWithTransaction:trans];
    [[MIDClient shared] checkoutWith:req completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
     {
         XCTAssertNotNil(token.token);
         
         [[MIDClient shared] fetchPaymentInfoWithToken:token.token
                                            completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error)
          {
              XCTAssertNil(error, @"Request create token error.");
              [promise fulfill];
          }];
     }];
    
    [self waitForExpectations:@[promise] timeout:60];
}

- (void)testFetchPaymentError {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [[MIDClient shared] fetchPaymentInfoWithToken:@""
                                       completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error)
     {
         XCTAssertNil(error, @"Request create token error.");
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:60];
}

@end
