//
//  MIDCreditCardTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 16/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MIDCreditCardTest : XCTestCase

@end

@implementation MIDCreditCardTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testChargeWithSaveCard {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    NSString *cardNumber = @"4811111111111114";
    
    [self getTokenWithCompletion:^(NSString * _Nullable snapToken, NSError * _Nullable error) {
        MIDTokenizeConfig *config = [MIDTokenizeConfig new];
        config.grossAmount = @200000;
        [MIDCreditCardTokenizer tokenizeCardNumber:cardNumber
                                               cvv:@"123"
                                       expireMonth:@"02"
                                        expireYear:@"20"
                                            config:config
                                        completion:^(MIDTokenizeResponse *_Nullable token, NSError * _Nullable error)
         {
             [MIDCreditCardCharge chargeWithToken:snapToken
                                        cardToken:token.tokenID
                                             save:YES
                                      installment:nil
                                            point:nil
                                       completion:^(MIDCreditCardResult * _Nullable result, NSError * _Nullable error)
              {
                  XCTAssertTrue(result.statusCode == 200);
                  [promise fulfill];
              }];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testChargeNormal {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    NSString *cardNumber = @"4811111111111114";
    
    [self getTokenWithCompletion:^(NSString * _Nullable snapToken, NSError * _Nullable error) {
        MIDTokenizeConfig *config = [MIDTokenizeConfig new];
        config.grossAmount = [MIDTestHelper grossAmount];
        config.enable3ds = YES;
        [MIDCreditCardTokenizer tokenizeCardNumber:cardNumber
                                               cvv:@"123"
                                       expireMonth:@"02"
                                        expireYear:@"20"
                                            config:config
                                        completion:^(MIDTokenizeResponse *_Nullable token, NSError * _Nullable error)
         {
             [MIDCreditCardCharge chargeWithToken:snapToken
                                        cardToken:token.tokenID
                                             save:YES
                                      installment:nil
                                            point:nil
                                       completion:^(MIDCreditCardResult * _Nullable result, NSError * _Nullable error)
              {
                  XCTAssertTrue(result.statusCode == 200);
                  [promise fulfill];
              }];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
