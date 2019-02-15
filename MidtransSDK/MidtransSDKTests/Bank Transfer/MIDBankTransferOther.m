//
//  MIDBankTransferOther.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 23/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDBankTransferOther : XCTestCase

@end

@implementation MIDBankTransferOther

static NSString *_email = @"jukiginanjar@yahoo.com";
static NSString *_phone = @"085223768857";
static NSString *_name = @"susan";

- (void)setUp {
    [MIDTestHelper setup];
}


- (void)testOtherBankTransfer {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString *_Nullable token, NSError *_Nullable error) {
        [MIDBankTransferCharge otherBankWithToken:token
                                             name:_name
                                            email:_email
                                            phone:_phone
                                       completion:^(id _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result, @"test other va is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testTokenNotFoundOther {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDBankTransferCharge otherBankWithToken:nil
                                         name:_name
                                        email:_email
                                        phone:_phone
                                   completion:^(id _Nullable result, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
