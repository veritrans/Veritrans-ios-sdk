//
//  MIDBankTransferMandiriTest.m
//  MidtransSDKTests
//
//  Created by Arie.Prasetiyo on 08/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"
@interface MIDBankTransferMandiriTest : XCTestCase

@end

@implementation MIDBankTransferMandiriTest

static NSString *_email = @"jukiginanjar@yahoo.com";
static NSString *_phone = @"085223768857";
static NSString *_name = @"susan";

- (void)setUp {
    [MIDTestHelper setup];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testForMandiri {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString *_Nullable token, NSError *_Nullable error) {
        [MIDBankTransferCharge mandiriWithToken:token
                                           name:_name
                                          email:_email
                                          phone:_phone
                                     completion:^(MIDMandiriBankTransferResult * _Nullable result, NSError * _Nullable error)
         {
             XCTAssertNotNil(result.key, @"va bni test is error");
             [promise fulfill];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}
- (void)testTokenNotFoundMandiri {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDBankTransferCharge mandiriWithToken:nil
                                       name:_name
                                      email:_email
                                      phone:_phone
                                 completion:^(MIDMandiriBankTransferResult * _Nullable result, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
