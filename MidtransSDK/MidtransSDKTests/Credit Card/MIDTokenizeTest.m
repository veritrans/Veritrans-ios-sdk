//
//  MIDTokenizeTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 28/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

static NSString *cardNumber = @"4811111111111114";

@interface MIDTokenizeTest : XCTestCase

@end

@implementation MIDTokenizeTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testTokenizeCard {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDTokenizeConfig *config = [MIDTokenizeConfig new];
    config.grossAmount = @200000;
    [MIDCreditCardTokenizer tokenizeCardNumber:cardNumber
                                           cvv:@"123"
                                   expireMonth:@"02"
                                    expireYear:@"20"
                                        config:config
                                    completion:^(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error)
     {
         XCTAssertTrue(token.statusCode == 200);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testTokenizeCard3ds {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDTokenizeConfig *config = [MIDTokenizeConfig new];
    config.grossAmount = @200000;
    config.enable3ds = YES;
    [MIDCreditCardTokenizer tokenizeCardNumber:cardNumber
                                           cvv:@"123"
                                   expireMonth:@"02"
                                    expireYear:@"20"
                                        config:config
                                    completion:^(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error)
     {
         XCTAssertNotNil(token.secureURL, @"3ds url unavailable");
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testTokenizeCardCustomBank {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDTokenizeConfig *config = [MIDTokenizeConfig new];
    config.grossAmount = @200000;
    config.bank = MIDBankTransferTypeBCA;
    [MIDCreditCardTokenizer tokenizeCardNumber:cardNumber
                                           cvv:@"123"
                                   expireMonth:@"02"
                                    expireYear:@"20"
                                        config:config
                                    completion:^(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error)
     {
         XCTAssertTrue([token.bank isEqualToString:@"bca"], @"bank is incorrect");
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testTokenizeErrorCard {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDTokenizeConfig *config = [MIDTokenizeConfig new];
    config.grossAmount = @200000;
    [MIDCreditCardTokenizer tokenizeCardNumber:@"0"
                                           cvv:@"0"
                                   expireMonth:@"0"
                                    expireYear:@"0"
                                        config:config
                                    completion:^(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error)
     {
         XCTAssertTrue(error.code == 400);
         [promise fulfill];
     }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
