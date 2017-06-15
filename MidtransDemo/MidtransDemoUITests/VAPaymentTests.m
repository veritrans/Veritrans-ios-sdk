//
//  MTVAPaymentTests.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/23/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface VAPaymentTests : XCTestCase

@end

@implementation VAPaymentTests

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

- (void)testVABCA {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self enterVAPaymentList:app];
    
    [app.tables.staticTexts[@"Pay from BCA ATMs or internet banking"] tap];
    [app.buttons[@"See Account Number"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish Payment"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

- (void)testVAMandiri {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self enterVAPaymentList:app];
    
    [app.tables.staticTexts[@"Pay from Mandiri ATMs or internet banking"] tap];
    [app.buttons[@"See Account Number"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish Payment"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

- (void)testVAPermata {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self enterVAPaymentList:app];
    
    [app.tables.staticTexts[@"Pay from Permata ATMs or internet banking"] tap];
    [app.buttons[@"See Account Number"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish Payment"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

- (void)testVAOtherBank {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self enterVAPaymentList:app];
    
    [app.tables.staticTexts[@"Pay from ATMs or internet banking"] tap];
    [app.buttons[@"See Account Number"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish Payment"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

#pragma mark - Helper

- (void)enterVAPaymentList:(XCUIApplication *)app {
    /*
     Do Transaction
     */
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    [app.sheets[@"Select Demo you want to see"].buttons[@"UI-FLOW Demo"] tap];
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay from ATM Bersama, Prima or Alto"];
    [self waitUntilAvailableForElement:creditCardCell];
    
    [creditCardCell tap];
}

@end
