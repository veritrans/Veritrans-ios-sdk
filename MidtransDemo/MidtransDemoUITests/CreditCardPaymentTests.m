//
//  MTCreditCardPaymentTests.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/13/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface CreditCardPaymentTests : XCTestCase

@end

@implementation CreditCardPaymentTests

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


- (void)testNormal {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *navbar = app.navigationBars[@"demo_navbar"];
    XCUIElement *settingBtn = navbar.buttons[@"demo_navbar_setting"];
    [settingBtn tap];
    
    //selet 2-clicks
    [self option:app selectAtIndex:0 thenChooseAtIndex:0];
    
    //enable 3ds
    [self option:app selectAtIndex:1 thenChooseAtIndex:0];
    
    //disable save card
    [self option:app selectAtIndex:4 thenChooseAtIndex:1];
    
    XCUIElement *button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_finish_option"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_buy"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_pay"] elementAtIndex:0];
    [button tap];
    
    XCUIElementQuery *cells = [[app.tables descendantsMatchingType:XCUIElementTypeCell] matchingIdentifier:@"mt_payment_method"];
    XCUIElement *cell = [cells elementAtIndex:0];
    [self waitUntilAvailableForElement:cell];
    [cell tap];
    
    XCUIElementQuery *textFields = [[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_textfield"];
    XCUIElement *numberText = [textFields elementAtIndex:0];
    [numberText enterText:@"4811111111111114"];
    
    XCUIElement *expiryText = [textFields elementAtIndex:1];
    [expiryText enterText:@"02 / 20"];
    
    XCUIElement *cvvText = [textFields elementAtIndex:2];
    [cvvText enterText:@"123"];
    
    XCUIElement *finishInputCard = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishInputCard tap];
    
    XCUIElement *otpText = [[app.webViews descendantsMatchingType:XCUIElementTypeSecureTextField] elementAtIndex:0];
    [self waitUntilAvailableForElement:otpText];
    [otpText enterText:@"112233"];
    
    XCUIElement *ok3ds = [app.webViews.buttons elementAtIndex:0];
    [ok3ds tap];
    
    XCUIElement *finishPayment = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishPayment tap];
}

- (void)testTwoClicks2 {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *navbar = app.navigationBars[@"demo_navbar"];
    XCUIElement *settingBtn = navbar.buttons[@"demo_navbar_setting"];
    [settingBtn tap];
    
    //selet 2-clicks
    [self option:app selectAtIndex:0 thenChooseAtIndex:1];
    
    //enable 3ds
    [self option:app selectAtIndex:1 thenChooseAtIndex:0];
    
    XCUIElement *button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_finish_option"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_buy"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_pay"] elementAtIndex:0];
    [button tap];
    
    XCUIElementQuery *cells = [[app.tables descendantsMatchingType:XCUIElementTypeCell] matchingIdentifier:@"mt_payment_method"];
    XCUIElement *cell = [cells elementAtIndex:0];
    [self waitUntilAvailableForElement:cell];
    [cell tap];
    
    cells = [[app.tables descendantsMatchingType:XCUIElementTypeCell] matchingIdentifier:@"mt_saved_card"];
    XCUIElement *savedCardCell = [cells elementAtIndex:0];
    if (savedCardCell.exists) {
        [savedCardCell tap];
        XCUIElement *cvvText = [[[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_textfield"] elementAtIndex:2];
        [cvvText enterText:@"123"];
    }
    else {
        XCTFail(@"There're no saved cards!");
    }
    
    XCUIElement *finishInputCard = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishInputCard tap];
    
    XCUIElement *otpText = [[app.webViews descendantsMatchingType:XCUIElementTypeSecureTextField] elementAtIndex:0];
    [self waitUntilAvailableForElement:otpText];
    [otpText enterText:@"112233"];
    
    XCUIElement *ok3DS = [app.webViews.buttons elementAtIndex:0];
    [ok3DS tap];
    
    XCUIElement *finishPayment = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishPayment tap];
}

- (void)testTwoClicks1 {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *navbar = app.navigationBars[@"demo_navbar"];
    XCUIElement *settingBtn = navbar.buttons[@"demo_navbar_setting"];
    [settingBtn tap];
    
    //selet 2-clicks
    [self option:app selectAtIndex:0 thenChooseAtIndex:1];
    
    //enable 3ds
    [self option:app selectAtIndex:1 thenChooseAtIndex:0];
    
    XCUIElement *button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_finish_option"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_buy"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_pay"] elementAtIndex:0];
    [button tap];
    
    XCUIElementQuery *cells = [[app.tables descendantsMatchingType:XCUIElementTypeCell] matchingIdentifier:@"mt_payment_method"];
    XCUIElement *cell = [cells elementAtIndex:0];
    [self waitUntilAvailableForElement:cell];
    [cell tap];
    
    XCUIElement *newCardBtn = [[app.tables.buttons matchingIdentifier:@"mt_new_card"] elementAtIndex:0];
    if (newCardBtn.exists) {
        [newCardBtn tap];
    }
    
    XCUIElement *saveCheckBox = [[[app.tables descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_checkbox"] elementAtIndex:0];
    if (saveCheckBox.selected == NO) {
        [saveCheckBox tap];
    }

    XCUIElementQuery *textFields = [[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_textfield"];
    XCUIElement *cardNumberText = [textFields elementAtIndex:0];
    [cardNumberText enterText:@"4811111111111114"];
    
    XCUIElement *expiryText = [textFields elementAtIndex:1];
    [expiryText enterText:@"02 / 20"];
    
    XCUIElement *cvvText = [textFields elementAtIndex:2];
    [cvvText enterText:@"123"];

    XCUIElement *finishInputCard = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishInputCard tap];
    
    XCUIElement *otpText = [[app.webViews descendantsMatchingType:XCUIElementTypeSecureTextField] elementAtIndex:0];
    [self waitUntilAvailableForElement:otpText];
    [otpText enterText:@"112233"];
    
    XCUIElement *ok3DS = [app.webViews.buttons elementAtIndex:0];
    [ok3DS tap];
    
    XCUIElement *finishPayment = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishPayment tap];
}


- (void)testOneClick1 {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *navbar = app.navigationBars[@"demo_navbar"];
    XCUIElement *settingBtn = navbar.buttons[@"demo_navbar_setting"];
    [settingBtn tap];
    
    //selet 1-click
    [self option:app selectAtIndex:0 thenChooseAtIndex:2];
    
    //enable 3ds
    [self option:app selectAtIndex:1 thenChooseAtIndex:0];
    
    XCUIElement *button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_finish_option"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_buy"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_pay"] elementAtIndex:0];
    [button tap];
    
    XCUIElementQuery *cells = [[app.tables descendantsMatchingType:XCUIElementTypeCell] matchingIdentifier:@"mt_payment_method"];
    XCUIElement *cell = [cells elementAtIndex:0];
    [self waitUntilAvailableForElement:cell];
    [cell tap];
    
    XCUIElement *newCardBtn = [[app.tables.buttons matchingIdentifier:@"mt_new_card"] elementAtIndex:0];
    if (newCardBtn.exists) {
        [newCardBtn tap];
    }
    
    XCUIElement *saveCheckBox = [[[app.tables descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_checkbox"] elementAtIndex:0];
    if (saveCheckBox.selected == NO) {
        [saveCheckBox tap];
    }
    
    XCUIElementQuery *textFields = [[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_textfield"];
    XCUIElement *cardNumberText = [textFields elementAtIndex:0];
    [cardNumberText enterText:@"4811111111111114"];
    
    XCUIElement *expiryText = [textFields elementAtIndex:1];
    [expiryText enterText:@"02 / 20"];
    
    XCUIElement *cvvText = [textFields elementAtIndex:2];
    [cvvText enterText:@"123"];
    
    XCUIElement *finishInputCard = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishInputCard tap];
    
    XCUIElement *otpText = [[app.webViews descendantsMatchingType:XCUIElementTypeSecureTextField] elementAtIndex:0];
    [self waitUntilAvailableForElement:otpText];
    [otpText enterText:@"112233"];
    
    XCUIElement *ok3DSBtn = [app.webViews.buttons elementAtIndex:0];
    [ok3DSBtn tap];
    
    XCUIElement *finishPayment = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishPayment tap];
}

- (void)testOneClick2 {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *navbar = app.navigationBars[@"demo_navbar"];
    XCUIElement *settingBtn = navbar.buttons[@"demo_navbar_setting"];
    [settingBtn tap];
    
    //selet 1-click
    [self option:app selectAtIndex:0 thenChooseAtIndex:2];
    
    //enable 3ds
    [self option:app selectAtIndex:1 thenChooseAtIndex:0];
    
    XCUIElement *button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_finish_option"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_buy"] elementAtIndex:0];
    [button tap];
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"demo_pay"] elementAtIndex:0];
    [button tap];
    
    XCUIElementQuery *cells = [[app.tables descendantsMatchingType:XCUIElementTypeCell] matchingIdentifier:@"mt_payment_method"];
    XCUIElement *cell = [cells elementAtIndex:0];
    [self waitUntilAvailableForElement:cell];
    [cell tap];
    
    cells = [[app.tables descendantsMatchingType:XCUIElementTypeCell] matchingIdentifier:@"mt_saved_card"];
    XCUIElement *savedCardCell = [cells elementAtIndex:0];
    if (savedCardCell.exists) {
        [savedCardCell tap];
        [app.buttons[@"Confirm"] tap];
        XCUIElement *finishPayment = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
        [finishPayment tap];
    }
    else {
        XCTFail(@"There're no saved cards!");
    }
}

- (void)testOnlineInstallment {
    
}

- (void)testOfflineInstallment {
    
}

- (void)testTwoClicksOfflineInstallment {
    
}

- (void)testTwoClicksOnlineInstallment {
    
}

- (void)testBNIPoint {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *navbar = app.navigationBars[@"demo_navbar"];
    XCUIElement *settingBtn = navbar.buttons[@"demo_navbar_setting"];
    [settingBtn tap];
    
    //selet 1-click
    [self option:app selectAtIndex:0 thenChooseAtIndex:0];
    //enable 3ds
    [self option:app selectAtIndex:1 thenChooseAtIndex:0];
    //set bni bank
    [self option:app selectAtIndex:2 thenChooseAtIndex:0];
    //disable save card
    [self option:app selectAtIndex:4 thenChooseAtIndex:1];
    
    XCUIElement *button = [[app.buttons matchingIdentifier:@"demo_finish_option"] elementAtIndex:0];
    [button tap];
    button = [[app.buttons matchingIdentifier:@"demo_buy"] elementAtIndex:0];
    [button tap];
    button = [[app.buttons matchingIdentifier:@"demo_pay"] elementAtIndex:0];
    [button tap];
    
    XCUIElementQuery *cells = [app.tables.cells matchingIdentifier:@"mt_payment_method"];
    XCUIElement *cell = [cells elementAtIndex:0];
    [self waitUntilAvailableForElement:cell];
    [cell tap];
    
    XCUIElementQuery *textFields = [[app descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_textfield"];
    XCUIElement *numberText = [textFields elementAtIndex:0];
    [numberText enterText:@"4105058689481467"];
    
    XCUIElement *expiryText = [textFields elementAtIndex:1];
    [expiryText enterText:@"02 / 20"];
    
    XCUIElement *cvvText = [textFields elementAtIndex:2];
    [cvvText enterText:@"123"];
    
    cells = [[app descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_checkbox"];
    XCUIElement *bniPointCheckbox = [cells elementAtIndex:0];
    if (bniPointCheckbox.selected == NO) {
        [bniPointCheckbox tap];
    }

    XCUIElement *finishInputCard = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishInputCard tap];
    
    XCUIElement *otpText = [app.webViews.secureTextFields elementAtIndex:0];
    [self waitUntilAvailableForElement:otpText];
    [otpText enterText:@"112233"];
    
    XCUIElement *ok3ds = [app.webViews.buttons elementAtIndex:0];
    [ok3ds tap];
    
    XCUIElement *finishBNIPoint = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [finishBNIPoint tap];
    
    XCUIElement *finishPayment = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [self waitUntilAvailableForElement:finishPayment];
    [finishPayment tap];
}

#pragma mark - Helper

- (void)option:(XCUIApplication *)app selectAtIndex:(NSInteger)index thenChooseAtIndex:(NSInteger)optionIndex {
    XCUIElementQuery *options = [[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"demo_option"];
    XCUIElement *option = [options  elementAtIndex:index];
    [option tap];
    XCUIElementQuery *cells = [[option descendantsMatchingType:XCUIElementTypeCell]  matchingIdentifier:@"demo_option_cell"];
    XCUIElement *optionCell = [cells elementAtIndex:optionIndex];
    [optionCell tap];
}

@end
