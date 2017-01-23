//
//  MTCreditCardPaymentTests.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/13/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MTTestHelper.h"

@interface MT1CreditCardPaymentTests : XCTestCase

@end

@implementation MT1CreditCardPaymentTests

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

- (void)test1CCNormalTransaction {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [MTTestHelper configureRequiredData:app];
    
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    /*
     Do CC Configuration for normal transaction
     */
    [app.navigationBars[@"Cart"].buttons[@"Setting"] tap];
    [other.buttons[@"Normal"] tap];
    
    XCUIElement *secureSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:0];
    if ([secureSwitch.value isEqualToString:@"0"]) {
        [secureSwitch tap];
    }
    XCUIElement *storageSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:1];
    if ([storageSwitch.value isEqualToString:@"1"]) {
        [storageSwitch tap];
    }
    XCUIElement *saveCardSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:2];
    if ([saveCardSwitch.value isEqualToString:@"1"]) {
        [saveCardSwitch tap];
    }
    
    [app.navigationBars[@"Customer Details"].buttons[@"Save"] tap];
    
    /*
     Do Transaction
     */
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    [app.sheets[@"Select Demo you want to see"].buttons[@"UI-FLOW Demo"] tap];
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay with Visa, MasterCard, or JCB"];
    [self waitUntilAvailableForElement:creditCardCell];
    
    [creditCardCell tap];
    
    XCUIElement *cardNumberTextField = other.textFields[@"Card Number"];
    [cardNumberTextField enterText:@"4811111111111114"];
    
    XCUIElement *expiryDateMmYyTextField = other.textFields[@"Expiry Date (mm/yy)"];
    [expiryDateMmYyTextField enterText:@"02 / 20"];
    
    XCUIElement *cvvTextField = other.secureTextFields[@"CVV"];
    [cvvTextField enterText:@"123"];
    
    [app.buttons[@"Done"] tap];
    
    [app.buttons[@"Finish Payment"] tap];
    
    XCUIElement *secureTextField = app.secureTextFields[@"112233"];
    [self waitUntilAvailableForElement:secureTextField];
    [secureTextField enterText:@"112233"];
    [app.buttons[@"OK"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

- (void)test2CCTwoClicksTransaction {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self twoClickInitial:app];
    
    [self twoClickFollowing:app];
}

- (void)test3CCOneClickTransaction {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self oneClickInitial:app];
    
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay with Visa, MasterCard, or JCB"];
    [self waitUntilAvailableForElement:creditCardCell];
    [creditCardCell tap];
    
    XCUIElement *saveCardCell = app.collectionViews.staticTexts[@"4811 11-1 114"];
    [self waitUntilAvailableForElement:saveCardCell];
    [saveCardCell tap];
    
    [app.buttons[@"Confirm"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

#pragma mark - Helper

- (void)oneClickInitial:(XCUIApplication *)app {
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    [app.navigationBars[@"Cart"].buttons[@"Setting"] tap];
    [other.buttons[@"1-Click"] tap];
    
    XCUIElement *secureSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:0];
    if ([secureSwitch.value isEqualToString:@"0"]) {
        [secureSwitch tap];
    }
    XCUIElement *storageSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:1];
    if ([storageSwitch.value isEqualToString:@"0"]) {
        [storageSwitch tap];
    }
    XCUIElement *saveCardSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:2];
    if ([saveCardSwitch.value isEqualToString:@"0"]) {
        [saveCardSwitch tap];
    }
    
    [app.navigationBars[@"Customer Details"].buttons[@"Save"] tap];
    
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    [app.sheets[@"Select Demo you want to see"].buttons[@"UI-FLOW Demo"] tap];
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay with Visa, MasterCard, or JCB"];
    [self waitUntilAvailableForElement:creditCardCell];
    [creditCardCell tap];
    
    XCUIElement *button = [[[[[other containingType:XCUIElementTypeTextField identifier:@"Card Number"] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0];
    if (!button.selected) {
        [button tap];
    }
    XCUIElement *cardNumberTextField = other.textFields[@"Card Number"];
    [cardNumberTextField enterText:@"4811111111111114"];
    XCUIElement *expiryDateMmYyTextField = other.textFields[@"Expiry Date (mm/yy)"];
    [expiryDateMmYyTextField enterText:@"02 / 20"];
    XCUIElement *cvvTextField = other.secureTextFields[@"CVV"];
    [cvvTextField enterText:@"123"];
    [app.buttons[@"Done"] tap];
    [app.buttons[@"Finish Payment"] tap];
    
    XCUIElement *secureTextField = app.secureTextFields[@"112233"];
    [self waitUntilAvailableForElement:secureTextField];
    [secureTextField enterText:@"112233"];
    [app.buttons[@"OK"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

- (void)twoClickInitial:(XCUIApplication *)app {
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    [app.navigationBars[@"Cart"].buttons[@"Setting"] tap];
    [other.buttons[@"2-Clicks"] tap];
    
    XCUIElement *secureSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:0];
    if ([secureSwitch.value isEqualToString:@"0"]) {
        [secureSwitch tap];
    }
    XCUIElement *storageSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:1];
    if ([storageSwitch.value isEqualToString:@"1"]) {
        [storageSwitch tap];
    }
    XCUIElement *saveCardSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:2];
    if ([saveCardSwitch.value isEqualToString:@"0"]) {
        [saveCardSwitch tap];
    }
    
    [app.navigationBars[@"Customer Details"].buttons[@"Save"] tap];
    
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    [app.sheets[@"Select Demo you want to see"].buttons[@"UI-FLOW Demo"] tap];
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay with Visa, MasterCard, or JCB"];
    [self waitUntilAvailableForElement:creditCardCell];
    [creditCardCell tap];
    
    XCUIElement *button = [[[[[other containingType:XCUIElementTypeTextField identifier:@"Card Number"] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0];
    if (!button.selected) {
        [button tap];
    }
    XCUIElement *cardNumberTextField = other.textFields[@"Card Number"];
    [cardNumberTextField enterText:@"4811111111111114"];
    XCUIElement *expiryDateMmYyTextField = other.textFields[@"Expiry Date (mm/yy)"];
    [expiryDateMmYyTextField enterText:@"02 / 20"];
    XCUIElement *cvvTextField = other.secureTextFields[@"CVV"];
    [cvvTextField enterText:@"123"];
    [app.buttons[@"Done"] tap];
    [app.buttons[@"Finish Payment"] tap];
    
    XCUIElement *secureTextField = app.secureTextFields[@"112233"];
    [self waitUntilAvailableForElement:secureTextField];
    [secureTextField enterText:@"112233"];
    [app.buttons[@"OK"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

- (void)twoClickFollowing:(XCUIApplication *)app {
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay with Visa, MasterCard, or JCB"];
    [self waitUntilAvailableForElement:creditCardCell];
    [creditCardCell tap];
    
    XCUIElement *saveCardCell = app.collectionViews.staticTexts[@"4811 11XX XXXX 1114 "];
    [self waitUntilAvailableForElement:saveCardCell];
    [saveCardCell tap];
    
    XCUIElement *cvvNumberSecureTextField = other.secureTextFields[@"CVV NUMBER"];
    [cvvNumberSecureTextField enterText:@"123"];
    
    [app.buttons[@"Done"] tap];
    [app.buttons[@"Finish Payment"] tap];
    
    XCUIElement *secureTextField = app.secureTextFields[@"112233"];
    [self waitUntilAvailableForElement:secureTextField];
    [secureTextField enterText:@"112233"];
    [app.buttons[@"OK"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

@end
