//
//  MandiriPaymentTest.m
//  VTDirectDemo
//
//  Created by atta on 6/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MandiriPaymentTest : XCTestCase

@end

@implementation MandiriPaymentTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    [self testMandiriPositiveFlow1];
    [self testMandiriPositiveFlow2];
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)testMandiriPositiveFlow1 {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"ATM/Bank Transfer"] tap];
    [tablesQuery.staticTexts[@"Mandiri"] tap];
    [app.buttons[@"Confirm Payment"] tap];
    [app.buttons[@"Close"] tap];
}


- (void)testMandiriPositiveFlow2 {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"Pay from ATM Bersama, Prima or Alto"] tap];
    [tablesQuery.staticTexts[@"Pay from Mandiri ATMs or internet banking"] tap];
    
    XCUIElement *emailAddressOptionalTextField = app.textFields[@"Email Address (optional)"];
    [emailAddressOptionalTextField tap];
    [emailAddressOptionalTextField tap];
    [emailAddressOptionalTextField tap];
    [emailAddressOptionalTextField tap];
    [app.buttons[@"How Can I Pay Via Mandiri Bank Transfer?"] tap];
    
    XCUIElement *internetBankingButton = app.buttons[@"Internet Banking"];
    [internetBankingButton tap];
    
    XCUIElement *atmMandiriButton = app.buttons[@"ATM Mandiri"];
    [atmMandiriButton tap];
    [internetBankingButton tap];
    [atmMandiriButton tap];
    [internetBankingButton tap];
    [atmMandiriButton tap];
    [internetBankingButton tap];
    [atmMandiriButton tap];
    [internetBankingButton tap];
    [atmMandiriButton tap];
    [internetBankingButton tap];
    [atmMandiriButton tap];
    [internetBankingButton tap];
    [atmMandiriButton tap];
    [internetBankingButton tap];
    [atmMandiriButton tap];
    [internetBankingButton tap];
    [atmMandiriButton tap];
    [app.buttons[@"Ok, I Got it"] tap];
    [app.buttons[@"Confirm Payment"] pressForDuration:0.7];
    [app.buttons[@"Close"] tap];
    
}
@end
