//
//  MIDKlikbcaTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 11/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDKlikbcaTest : XCTestCase

@end

@implementation MIDKlikbcaTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testSuccessKlikbca {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        NSString *klikbcaUser = @"SUSAN0707";
        [MIDDirectDebitCharge klikbcaWithToken:token
                                        userID:klikbcaUser
                                    completion:^(MIDKlikbcaResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.approvalCode, @"klikbca test is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyUserKlikbca {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDDirectDebitCharge klikbcaWithToken:token
                                        userID:nil
                                    completion:^(MIDKlikbcaResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertTrue(error.code == 400);
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testEmptyTokenKlikbca {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDDirectDebitCharge klikbcaWithToken:nil
                                    userID:@"SUSAN0707"
                                completion:^(MIDKlikbcaResult * _Nullable result, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
