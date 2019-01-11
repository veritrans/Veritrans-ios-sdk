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
static NSString *_email = @"test-mobile@midtrans.com";

- (void)setUp {
    [MIDTestHelper setup];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testForMandiri {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [MIDBankTransferCharge mandiriWithToken:token email:_email completion:^(MIDMandiriBankTransferResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result.key, @"va bni test is error");
            [promise fulfill];
        }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}
- (void)testTokenNotFoundMandiri {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [MIDBankTransferCharge mandiriWithToken:nil
                                  email:_email
                             completion:^(MIDMandiriBankTransferResult * _Nullable result, NSError * _Nullable error)
     {
         XCTAssertTrue(error.code == 404);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)getTokenWithCompletion:(void (^_Nullable) (NSString *_Nullable token, NSError *_Nullable error))completion {
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:[MIDTestHelper orderID]
                                                                      grossAmount:@20000
                                                                         currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx options:nil completion:^(MIDToken * _Nullable token, NSError * _Nullable error) {
        NSString *_token = token.token;
        XCTAssertNotNil(_token);
        completion(_token, error);
    }];
    
}
@end
