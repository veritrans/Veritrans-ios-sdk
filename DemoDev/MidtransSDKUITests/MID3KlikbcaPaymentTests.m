//
//  MT3KlikbcaPaymentTests.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/23/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MID3KlikbcaPaymentTests : XCTestCase

@end

@implementation MID3KlikbcaPaymentTests

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

- (void)testKlikbcaPayment {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    [app.sheets[@"Select Demo you want to see"].buttons[@"UI-FLOW Demo"] tap];
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay using KlikBCA"];
    [self waitUntilAvailableForElement:creditCardCell];
    [creditCardCell tap];
    
    XCUIElement *usernameTextField = app.textFields[@"KlikBCA User ID"];
    [usernameTextField enterText:@"JUKIGI0909"];
    [app.buttons[@"Done"] tap];
    [app.buttons[@"Confirm Payment"] tap];
    
    XCUIElement *completeButton = app.buttons[@"Complete Payment At KlikBCA"];
    [self waitUntilAvailableForElement:completeButton];
    [completeButton tap];
}

@end
