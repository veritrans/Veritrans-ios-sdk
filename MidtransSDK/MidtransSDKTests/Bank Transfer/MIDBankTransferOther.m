//
//  MIDBankTransferOther.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 23/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

static NSString *_email = @"test-mobile@midtrans.com";

@interface MIDBankTransferOther : XCTestCase

@end

@implementation MIDBankTransferOther

- (void)setUp {
    [MIDTestHelper setup];
}


- (void)testOtherBankTransfer {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDBankTransferCharge otherWithToken:token email:_email completion:^(id _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result, @"test other va is error");
            [promise fulfill];
        }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testTokenNotFoundOther {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDBankTransferCharge otherWithToken:nil email:_email completion:^(id _Nullable result, NSError * _Nullable error) {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
