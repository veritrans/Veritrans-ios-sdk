//
//  BCAPaymentTest.m
//  VTDirectDemo
//
//  Created by atta on 6/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BCAPaymentTest : XCTestCase

@end

@implementation BCAPaymentTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
- (void)testBCAPositivePayment1 {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"ATM/Bank Transfer"] tap];
    [tablesQuery.staticTexts[@"Pay from BCA ATMs or internet banking"] tap];
    [app.images[@"DetailDisclosure.png"] tap];
    
    XCUIElement *onceYouConfirmPaymentYouWillBeUnableToChangePaymentMethodStaticText = app.staticTexts[@"Once you confirm payment, you will be unable to change payment method"];
    [onceYouConfirmPaymentYouWillBeUnableToChangePaymentMethodStaticText tap];
    [onceYouConfirmPaymentYouWillBeUnableToChangePaymentMethodStaticText tap];
    
    XCUIElement *howCanIPayViaBcaBankTransferButton = app.buttons[@"How Can I Pay Via BCA Bank Transfer?"];
    [howCanIPayViaBcaBankTransferButton tap];
    
    XCUIElement *klikBcaButton = app.buttons[@"Klik BCA"];
    [klikBcaButton tap];
    
    XCUIElement *mBcaButton = app.buttons[@"m-BCA"];
    [mBcaButton tap];
    
    XCUIElement *atmBcaButton = app.buttons[@"ATM BCA"];
    [atmBcaButton tap];
    [klikBcaButton tap];
    [mBcaButton tap];
    [klikBcaButton tap];
    [atmBcaButton tap];
    [klikBcaButton tap];
    [mBcaButton tap];
    
}
- (void)testBCAPositivePayment2 {
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"ATM/Bank Transfer"] tap];
    [tablesQuery.staticTexts[@"Pay from BCA ATMs or internet banking"] tap];
    [app.textFields[@"Email Address (optional)"] tap];
    [app.buttons[@"How Can I Pay Via BCA Bank Transfer?"] tap];
    
    XCUIElement *klikBcaButton = app.buttons[@"Klik BCA"];
    [klikBcaButton tap];
    
    XCUIApplication *app2 = app;
    [app2.buttons[@"m-BCA"] tap];
    [klikBcaButton tap];
    [app2.buttons[@"ATM BCA"] tap];
    [app.buttons[@"Ok, I Got it"] tap];
    [app.buttons[@"Confirm Payment"] tap];
    [app.buttons[@"Copy VA Number"] tap];
    [[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element tap];
    [app.buttons[@"Finish Payment"] tap];
    
    
}
- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
