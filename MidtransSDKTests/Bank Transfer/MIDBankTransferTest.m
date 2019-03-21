//
//  MIDBankTransferTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 05/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDBankTransferTest : XCTestCase

@end

@implementation MIDBankTransferTest

static NSString *_email = @"jukiginanjar@yahoo.com";
static NSString *_phone = @"085223768857";
static NSString *_name = @"susan";

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testForBCA {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString *_Nullable token, NSError *_Nullable error) {
        [MIDBankTransferCharge bcaWithToken:token
                                       name:_name
                                      email:_email
                                      phone:_phone
                                 completion:^(MIDBCABankTransferResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.vaNumber, @"va bca test is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testTokenNotFoundBCA {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDBankTransferCharge bcaWithToken:nil
                                   name:_name
                                  email:_email
                                  phone:_phone
                             completion:^(MIDBCABankTransferResult * _Nullable result, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testTokenErrorBCA {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDBankTransferCharge bcaWithToken:@"random_token_error"
                                   name:_name
                                  email:_email
                                  phone:_phone
                             completion:^(MIDBCABankTransferResult * _Nullable result, NSError * _Nullable error)    
     {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
