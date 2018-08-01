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
    self.result = [[MidtransTransactionResult alloc] initWithTransactionResponse:self.response];
}

- (void)tearDown {

    [super tearDown];
    self.error = nil;
    self.result = nil;
}

- (void)testIndonesian {

}

- (void)testEnglish {
    
}

- (void)testHTTPStatusCodes {
    
}

- (void)testMidtransLocalizedErrorMessage {

}

- (void)testUnknownError {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"An unknown error occurred.", nil)};
    self.error = [NSError errorWithDomain:@"com.midtrans.MidtransKit"
                                         code:kCFURLErrorUnknown
                                     userInfo:userInfo];
    NSString* localizedMidtransErrorMessage = [self.error localizedMidtransErrorMessage];
    XCTAssertEqualObjects(localizedMidtransErrorMessage, @"An unknown error occurred.");
}

- (void)test400 {
    
}

@end
