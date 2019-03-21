//
//  MIDCreditCardTest.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 16/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

static NSString *cardNumber = @"4811111111111114";

@interface MIDCreditCardTest : XCTestCase

@end

@implementation MIDCreditCardTest

- (void)setUp {
    [MIDTestHelper setup];
}

- (void)testChargeNormal {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    [self getTokenWithCompletion:^(NSString *_Nullable snapToken, NSError *_Nullable error) {
        MIDTokenizeConfig *config = [MIDTokenizeConfig new];
        config.grossAmount = @200000;
        [MIDCreditCardTokenizer tokenizeCardNumber:cardNumber
                                               cvv:@"123"
                                       expireMonth:@"02"
                                        expireYear:@"20"
                                            config:config
                                        completion:^(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error)
         {
             [MIDCreditCardCharge chargeWithToken:snapToken
                                        cardToken:token.tokenID
                                             save:NO
                                      installment:nil
                                            point:nil
                                            promo:nil
                                       completion:^(MIDCreditCardResult *_Nullable result, NSError *_Nullable error)
              {
                  XCTAssertTrue(result.statusCode == 200);
                  [promise fulfill];
              }];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

- (void)testChargeSavedCard {
    XCTestExpectation *promise = [XCTestExpectation new];
    
    MIDCreditCard *cc = [[MIDCreditCard alloc] initWithCreditCardTransactionType:MIDCreditCardTransactionTypeAuthorizeCapture
                                                                  authentication:MIDAuthenticationNone
                                                                   acquiringBank:MIDAcquiringBankNone
                                                                acquiringChannel:MIDAcquiringChannelNone
                                                                     installment:nil
                                                                   whiteListBins:nil
                                                                   blackListBins:nil];
    
    [self getTokenWithOptions:@[cc] completion:^(NSString *_Nullable snapToken, NSError *_Nullable error) {
        MIDTokenizeConfig *config = [MIDTokenizeConfig new];
        config.grossAmount = [MIDTestHelper grossAmount];
        
        [MIDCreditCardTokenizer tokenizeCardNumber:cardNumber
                                               cvv:@"123"
                                       expireMonth:@"02"
                                        expireYear:@"20"
                                            config:config
                                        completion:^(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error)
         {
             [MIDCreditCardCharge chargeWithToken:snapToken
                                        cardToken:token.tokenID
                                             save:YES
                                      installment:nil
                                            point:nil
                                            promo:nil
                                       completion:^(MIDCreditCardResult *_Nullable result, NSError *_Nullable error)
              {
                  XCTAssertTrue(result.cardToken != nil);
                  [promise fulfill];
              }];
         }];
    }];
    
    [self waitForExpectations:@[promise] timeout:120];
}

@end
