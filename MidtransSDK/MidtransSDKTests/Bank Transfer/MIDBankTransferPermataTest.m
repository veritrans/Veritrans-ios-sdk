//
//  MIDBankTransferMandiriTest.m
//  MidtransSDKTests
//
//  Created by Arie.Prasetiyo on 08/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDBankTransferPermataTest : XCTestCase

@end

@implementation MIDBankTransferPermataTest
static NSString *_email = @"test-mobile@midtrans.com";

- (void)setUp {
    [MIDTestHelper setup];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testForPermata {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDBankTransferCharge permataWithToken:token
                                          email:_email
                                     completion:^(MIDPermataBankTransferResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result.vaNumber, @"va bni test is error");
            [promise fulfill];
        }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}
- (void)testTokenNotFoundPermata {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDBankTransferCharge permataWithToken:nil
                                      email:_email
                                 completion:^(MIDPermataBankTransferResult * _Nullable result, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
