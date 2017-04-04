//
//  MID4WebPaymentTests.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/10/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MID4WebPaymentTests : XCTestCase
@property (nonatomic) XCUIApplication *app;
@end

@implementation MID4WebPaymentTests

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

- (void)testKlikPay {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self enterPaymentList:app];

    XCUIElement *klikPayButton = app.tables.staticTexts[@"BCA KlikPay"];
    [self waitUntilAvailableForElement:klikPayButton];
    [klikPayButton tap];
    [app.buttons[@"Confirm Payment"] tap];
    
    XCUIElement *bayarButton = app.buttons[@"Bayar"];
    [self waitUntilAvailableForElement:bayarButton];
    [bayarButton tap];
    
    XCUIElement *backButton = app.buttons[@"Kembali ke Website Merchant"];
    [self waitUntilAvailableForElement:backButton];
    [backButton tap];
    
    XCUIElement *backToCartButton = app.navigationBars[@"Choose your payment mode"].buttons[@"Cart"];
    [self waitUntilAvailableForElement:backToCartButton];
    [backToCartButton tap];
}

- (void)testCIMBClicks {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self enterPaymentList:app];
    
    XCUIElement *clicksButton = app.tables.staticTexts[@"CIMB Clicks"];
    [self waitUntilAvailableForElement:clicksButton];
    [clicksButton tap];
    [app.buttons[@"Confirm Payment"] tap];
    
    XCUIElement *userTextField = app.textFields[@"Success user is 'testuser00'"];
    [self waitUntilAvailableForElement:userTextField];
    [userTextField enterText:@"testuser00"];
    [app.buttons[@"Bayar"] tap];
    
    XCUIElement *backButton = app.buttons[@"Kembali ke website Merchant"];
    [self waitUntilAvailableForElement:backButton];
    [backButton tap];
    
    XCUIElement *backToCartButton = app.navigationBars[@"Choose your payment mode"].buttons[@"Cart"];
    [self waitUntilAvailableForElement:backToCartButton];
    [backToCartButton tap];
}

- (void)testBRIEpay {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self enterPaymentList:app];
    
    XCUIElement *epayButton = app.tables.staticTexts[@"e-Pay BRI"];
    [self waitUntilAvailableForElement:epayButton];
    [epayButton tap];
    [app.buttons[@"Confirm Payment"] tap];
    
    XCUIElement *userTextField = app.textFields[@"Success user is 'testuser00'"];
    [self waitUntilAvailableForElement:userTextField];
    [userTextField enterText:@"testuser00"];
    [app.buttons[@"Bayar"] tap];
    
    XCUIElement *backButton = app.buttons[@"Kembali ke website Merchant"];
    [self waitUntilAvailableForElement:backButton];
    [backButton tap];
    
    XCUIElement *backToCartButton = app.navigationBars[@"Choose your payment mode"].buttons[@"Cart"];
    [self waitUntilAvailableForElement:backToCartButton];
    [backToCartButton tap];
}

- (void)testMandiriEcash {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self enterPaymentList:app];
    
    XCUIElement *cell = app.tables.staticTexts[@"Mandiri e-Cash"];
    [self waitUntilAvailableForElement:cell];
    [cell tap];
    [app.buttons[@"Confirm Payment"] tap];
    
    XCUIElement *textField = app.textFields[@"0987654321 for success"];
    [self waitUntilAvailableForElement:textField];
    [textField enterText:@"0987654321"];
    [app.toolbars.buttons[@"Done"] tap];
    textField = app.secureTextFields[@"12345 for success"];
    [textField enterText:@"12345"];
    [app.buttons[@"Proceed"] tap];
    
    textField = app.secureTextFields[@"12123434 for success"];
    [self waitUntilAvailableForElement:textField];
    [textField enterText:@"12123434"];
    [app.buttons[@"Proceed"] tap];
    
    XCUIElement *backButton = app.staticTexts[@"Back to Merchant"];
    [self waitUntilAvailableForElement:backButton];
    [backButton tap];
    
    XCUIElement *backToCartButton = app.navigationBars[@"Choose your payment mode"].buttons[@"Cart"];
    [self waitUntilAvailableForElement:backToCartButton];
    [backToCartButton tap];
}

#pragma mark - Helper

- (void)enterPaymentList:(XCUIApplication *)app {
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    [app.sheets[@"Select Demo you want to see"].buttons[@"UI-FLOW Demo"] tap];
    [app.tables.staticTexts[@"Normal Payment"] tap];
}

@end
