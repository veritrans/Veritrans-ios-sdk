//
//  MidtransKitTests.m
//  MidtransKitTests
//
//  Created by Tommy.Yohanes on 31/07/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VTClassHelper.h"

@interface AlertErrorMessageTests : XCTestCase
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSString *MidtransErrorDomain;
@property (nonatomic, strong) MidtransTransactionResult *result;
@property (nonatomic, strong) NSDictionary *response;
@end

@implementation AlertErrorMessageTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {

    [super tearDown];
    self.error = nil;
    self.result = nil;
}

- (void)testUnknownError {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"An unknown error occurred.", nil)};
    self.error = [NSError errorWithDomain:@"com.midtrans.MidtransKit"
                                         code:kCFURLErrorUnknown
                                     userInfo:userInfo];
    NSString* localizedMidtransErrorMessage = [self.error localizedMidtransErrorMessage];
    XCTAssertEqualObjects(localizedMidtransErrorMessage, @"An unknown error occurred.");
}

- (void)testOtherNSErrors {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"blablabla", nil)};
    self.error = [NSError errorWithDomain:@"com.midtrans.MidtransKit"
                                     code:kCFURLErrorUnknown
                                 userInfo:userInfo];
    NSString* localizedMidtransErrorMessage = [self.error localizedMidtransErrorMessage];
    XCTAssertEqualObjects(localizedMidtransErrorMessage, @"Transaction is unsuccesful. Please try again with another card or with a different payment method.");
}

- (void)test400 {
    NSString *code = @"error_400";
    NSString *string = [VTClassHelper getTranslationFromAppBundleForString:code];
    XCTAssertEqualObjects(string, @"Transaction cannot be processed. Please make sure you have entered the correct payment details.");
}
- (void)test200 {
    NSString *code = @"error_200";
    NSString *string = [VTClassHelper getTranslationFromAppBundleForString:code];
    XCTAssertEqualObjects(string, @"Transaction success.");
}
- (void)test500 {
    NSString *code = @"error_500";
    NSString *string = [VTClassHelper getTranslationFromAppBundleForString:code];
    XCTAssertEqualObjects(string, @"We are experiencing some unexpected system error. Please try again.");
}
- (void)testHTTPOthers {
    NSString *code = @"error_others";
    NSString *string = [VTClassHelper getTranslationFromAppBundleForString:code];
    XCTAssertEqualObjects(string, @"Transaction is unsuccesful. Please try again with another card or with a different payment method.");
}

- (void)testNil {
    NSString *code = @"balblalablal";
    NSString *string = [VTClassHelper getTranslationFromAppBundleForString:code];
    XCTAssertNil(string);
}

@end
