//
//  MTCreditCardPaymentTests.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/13/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDTestHelper.h"

@interface MID1CreditCardPaymentTests : XCTestCase

@end

@implementation MID1CreditCardPaymentTests

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
    [cell tap];
    
    XCUIElementQuery *textFields = [[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_textfield"];
    XCUIElement *textField = [textFields elementAtIndex:0];
    [textField enterText:@"4811111111111114"];
    
    textField = [textFields elementAtIndex:1];
    [textField enterText:@"02 / 20"];
    
    textField = [textFields elementAtIndex:2];
    [textField enterText:@"123"];
    
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [button tap];
    
    textField = [[app.webViews descendantsMatchingType:XCUIElementTypeSecureTextField] elementAtIndex:0];
    [textField enterText:@"112233"];
    
    button = [app.webViews.buttons elementAtIndex:0];
    [button tap];
    
    button = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [button tap];
}

- (void)test2CCTwoClicksTransaction {
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
    [cell tap];
    
    cells = [[app.tables descendantsMatchingType:XCUIElementTypeCell] matchingIdentifier:@"mt_saved_card"];
    cell = [cells elementAtIndex:0];
    if (cell.exists) {
        //has saved card
        [cell tap];
        
        XCUIElement *textField = [[[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_textfield"] elementAtIndex:2];
        [textField enterText:@"123"];
    }
    else {
        button = [[[app.tables descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_checkbox"] elementAtIndex:0];
        if (button.selected == NO) {
            [button tap];
        }
        
        XCUIElementQuery *textFields = [[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_textfield"];
        XCUIElement *textField = [textFields elementAtIndex:0];
        [textField enterText:@"4811111111111114"];
        
        textField = [textFields elementAtIndex:1];
        [textField enterText:@"02 / 20"];
        
        textField = [textFields elementAtIndex:2];
        [textField enterText:@"123"];
    }
    
    button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [button tap];
    
    XCUIElement *textField = [[app.webViews descendantsMatchingType:XCUIElementTypeSecureTextField] elementAtIndex:0];
    [textField enterText:@"112233"];
    
    button = [app.webViews.buttons elementAtIndex:0];
    [button tap];
    
    button = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [button tap];
}

- (void)test3CCOneClickTransaction {
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
    cell = [cells elementAtIndex:0];
    if (cell.exists) {
        //has saved card
        [cell tap];
        [app.buttons[@"Confirm"] tap];
    }
    else {
        button = [[[app.tables descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_checkbox"] elementAtIndex:0];
        if (button.selected == NO) {
            [button tap];
        }
        
        XCUIElementQuery *textFields = [[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"mt_textfield"];
        XCUIElement *textField = [textFields elementAtIndex:0];
        [textField enterText:@"4811111111111114"];
        
        textField = [textFields elementAtIndex:1];
        [textField enterText:@"02 / 20"];
        
        textField = [textFields elementAtIndex:2];
        [textField enterText:@"123"];
        
        button = [[[app descendantsMatchingType:XCUIElementTypeButton] matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
        [button tap];
        
        textField = [[app.webViews descendantsMatchingType:XCUIElementTypeSecureTextField] elementAtIndex:0];
        [textField enterText:@"112233"];
        
        button = [app.webViews.buttons elementAtIndex:0];
        [button tap];
    }
    
    button = [[app.buttons matchingIdentifier:@"mt_finish_btn"] elementAtIndex:0];
    [button tap];
}

- (void)test4OnlineInstallmentAndPoint {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self setNormalCreditCardPaymentWithApp:app];
    
    [self setAcquiringBank:@"BNI" withApp:app];
    [self enterCreditCardPaymentPageWithApp:app];
    
    [self inputCardNumber:@"4105058689481467" expDate:@"02 / 20" cvv:@"123" withApp:app];
    
    [self doInstallmentWith3DSEnabled:YES andApp:app];
}

- (void)test5OfflineInstallment {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self setNormalCreditCardPaymentWithApp:app];
    [self enterCreditCardPaymentPageWithApp:app];
    [self inputCardNumber:@"4811111111111114" expDate:@"02 / 20" cvv:@"123" withApp:app];
    [self doInstallmentWith3DSEnabled:YES andApp:app];
}

- (void)test6TwoClicksOfflineInstallment {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self twoClickInitial:app];
    
    [self twoClickFollowingWithInstallment:YES andApp:app];
}

#pragma mark - Helper

- (void)setAcquiringBank:(NSString *)bank withApp:(XCUIApplication *)app {
    [app.navigationBars[@"Cart"].buttons[@"Setting"] tap];
    [app.scrollViews.otherElements.buttons[@"acquiring_bank"] tap];
    [app.tables.staticTexts[bank] tap];
    [app.navigationBars[@"Customer Details"].buttons[@"Save"] tap];
}

- (void)doInstallmentWith3DSEnabled:(BOOL)enable3ds andApp:(XCUIApplication *)app {
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    XCUIElement *installmentPlusButton = [[[[[[other containingType:XCUIElementTypeTextField identifier:@"Card Number"] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1];
    [installmentPlusButton tap];
    
    
    [app.buttons[@"Finish Payment"] tap];
    
    if (enable3ds) {
        [self input3DSecureOTP:app];
    }
    
    XCUIElement *finishBNIPointButton = app.buttons[@"Finish Payment"];
    [self waitUntilAvailableForElement:finishBNIPointButton];
    [finishBNIPointButton tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
    
    [app.navigationBars[@"Choose your payment mode"].buttons[@"Cart"] tap];
}

- (void)inputCardNumber:(NSString *)cardNumber expDate:(NSString *)expDate cvv:(NSString *)cvv withApp:(XCUIApplication *)app {
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    XCUIElement *cardNumberTextField = other.textFields[@"Card Number"];
    [cardNumberTextField enterText:cardNumber];
    
    XCUIElement *expiryDateMmYyTextField = other.textFields[@"Expiry Date (mm/yy)"];
    [expiryDateMmYyTextField enterText:expDate];
    
    XCUIElement *cvvTextField = other.secureTextFields[@"CVV"];
    [cvvTextField enterText:cvv];
}

- (void)input3DSecureOTP:(XCUIApplication *)app {
    XCUIElement *secureTextField = app.webViews.secureTextFields[@"112233"];
    [self waitUntilAvailableForElement:secureTextField];
    [secureTextField tap];
    sleep(1);
    [secureTextField typeText:@"112233"];
    [app.buttons[@"OK"] tap];
}

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
    
    [self enterCreditCardPaymentPageWithApp:app];
    
    [self inputCardNumber:@"4811111111111114" expDate:@"02 / 20" cvv:@"123" withApp:app];
    
    [app.buttons[@"Finish Payment"] tap];
    
    [self input3DSecureOTP:app];
    
    XCUIElement *finishButton = app.buttons[@"Close"];
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
    if ([storageSwitch.value isEqualToString:@"0"]) {
        [storageSwitch tap];
    }
    XCUIElement *saveCardSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:2];
    if ([saveCardSwitch.value isEqualToString:@"0"]) {
        [saveCardSwitch tap];
    }
    
    [app.navigationBars[@"Customer Details"].buttons[@"Save"] tap];
    
    [self enterCreditCardPaymentPageWithApp:app];
    
    [self inputCardNumber:@"4811111111111114" expDate:@"02 / 20" cvv:@"123" withApp:app];
    
    [app.buttons[@"Finish Payment"] tap];
    
    [self input3DSecureOTP:app];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

- (void)twoClickFollowingWithInstallment:(BOOL)withInstallment andApp:(XCUIApplication *)app {
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay With Visa, Mastercard, Jcb, Amex"];
    [self waitUntilAvailableForElement:creditCardCell];
    [creditCardCell tap];
    
    XCUIElement *saveCardCell = app.tables.staticTexts[@"Visa"];
    [self waitUntilAvailableForElement:saveCardCell];
    [saveCardCell tap];
    
    XCUIElement *cvvNumberSecureTextField = other.secureTextFields[@"CVV"];
    [cvvNumberSecureTextField enterText:@"123"];
    
    [app.buttons[@"Done"] tap];
    
    if (withInstallment) {
        XCUIElement *installmentPlusButton = [[[[[[other containingType:XCUIElementTypeTextField identifier:@"Card Number"] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1];
        [installmentPlusButton tap];
    }
    
    [app.buttons[@"Finish Payment"] tap];
    
    [self input3DSecureOTP:app];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

- (void)setNormalCreditCardPaymentWithApp:(XCUIApplication *)app {
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
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
    
}

- (void)enterCreditCardPaymentPageWithApp:(XCUIApplication *)app {
    [app.navigationBars[@"Cart"].buttons[@"Checkout"] tap];
    [app.sheets[@"Select Demo you want to see"].buttons[@"UI-FLOW Demo"] tap];
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay With Visa, Mastercard, Jcb, Amex"];
    [self waitUntilAvailableForElement:creditCardCell];
    
    [creditCardCell tap];
}

- (void)option:(XCUIApplication *)app selectAtIndex:(NSInteger)index thenChooseAtIndex:(NSInteger)optionIndex {
    XCUIElementQuery *options = [[app.scrollViews descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:@"demo_option"];
    XCUIElement *option = [options  elementAtIndex:index];
    [option tap];
    XCUIElementQuery *cells = [[option descendantsMatchingType:XCUIElementTypeCell]  matchingIdentifier:@"demo_option_cell"];
    XCUIElement *optionCell = [cells elementAtIndex:optionIndex];
    [optionCell tap];
}

@end
