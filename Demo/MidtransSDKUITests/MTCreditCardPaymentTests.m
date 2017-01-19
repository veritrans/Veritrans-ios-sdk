//
//  MTCreditCardPaymentTests.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/13/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCUIElement+Textfield.h"

@interface MTCreditCardPaymentTests : XCTestCase

@end

@implementation MTCreditCardPaymentTests

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

- (void)test1FillingCustomerData {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    [app.navigationBars[@"Cart"].buttons[@"Setting"] tap];
    
    XCUIElementQuery *cardPaymentOptionsElementsQuery = [other containingType:XCUIElementTypeStaticText identifier:@"Card Payment Options"];
    XCUIElement *firstNameTextField = [[[cardPaymentOptionsElementsQuery childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"First Name"] elementBoundByIndex:0];
    [firstNameTextField enterText:@"Nanang"];
    
    XCUIElement *lastNameTextField = [[[cardPaymentOptionsElementsQuery childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"Last Name"] elementBoundByIndex:0];
    [lastNameTextField enterText:@"Rafsanjani"];
    
    XCUIElement *emailTextField = other.textFields[@"Email"];
    [emailTextField enterText:@"jukiginanjar@rafsanjani.com"];
    
    XCUIElement *phoneTextField = [[[cardPaymentOptionsElementsQuery childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"Phone"] elementBoundByIndex:0];
    [phoneTextField enterText:@"08985999286"];
    
    
    XCUIElement *firstNameBillingTF = [[[cardPaymentOptionsElementsQuery childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"First Name"] elementBoundByIndex:1];
    [firstNameBillingTF enterText:@"Nanang"];
    
    XCUIElement *lastNameBillingTF = [[[cardPaymentOptionsElementsQuery childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"Last Name"] elementBoundByIndex:1];
    [lastNameBillingTF enterText:@"Rafsanjani"];
    
    XCUIElement *phoneBillingTF = [[[cardPaymentOptionsElementsQuery childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"Phone"] elementBoundByIndex:1];
    [phoneBillingTF enterText:@"08985999287"];
    
    XCUIElement *countryBillingTF = [[other containingType:XCUIElementTypeStaticText identifier:@"Card Payment Options"] childrenMatchingType:XCUIElementTypeTextField][@"Country"];
    [countryBillingTF enterText:@"Indonesia"];
    
    XCUIElement *cityBillingTF = [[other containingType:XCUIElementTypeStaticText identifier:@"Card Payment Options"] childrenMatchingType:XCUIElementTypeTextField][@"City"];
    [cityBillingTF enterText:@"Bandung"];
    
    XCUIElement *postalBillingTF = [[other containingType:XCUIElementTypeStaticText identifier:@"Card Payment Options"] childrenMatchingType:XCUIElementTypeTextField][@"Postal Code"];
    [postalBillingTF enterText:@"48448"];
    
    XCUIElement *addressBillingTF = [[other containingType:XCUIElementTypeStaticText identifier:@"Card Payment Options"] childrenMatchingType:XCUIElementTypeTextField][@"Address"];
    [addressBillingTF enterText:@"Lengkong"];
    
    XCUIElement *sameShippingAsBillingSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:3];
    if ([sameShippingAsBillingSwitch.value isEqualToString:@"0"]) {
        [sameShippingAsBillingSwitch tap];
    }
    
    [app.navigationBars[@"Customer Details"].buttons[@"Save"] tap];
}

- (void)test2CCNormalTransaction {
    XCUIApplication *app = [[XCUIApplication alloc] init];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:creditCardCell handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
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
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:secureTextField handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [secureTextField enterText:@"112233"];
    [app.buttons[@"OK"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:finishButton handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [finishButton tap];
}

- (void)test3CCTwoClicksTransaction {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self twoClickInitial:app];
    
    [self twoClickFollowing:app];
}

- (void)test4CCOneClickTransaction {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self oneClickInitial:app];
    
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay with Visa, MasterCard, or JCB"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:creditCardCell handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [creditCardCell tap];
    
    XCUIElement *saveCardCell = app.collectionViews.staticTexts[@"4811 11-1 114"];
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:saveCardCell handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [saveCardCell tap];
    
    XCUIElement *confirmButton = app.buttons[@"Confirm"];
    [confirmButton tap];
    predicate = [NSPredicate predicateWithFormat:@"exists == 0"];
    [self expectationForPredicate:predicate evaluatedWithObject:confirmButton handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:creditCardCell handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
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
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:secureTextField handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [secureTextField enterText:@"112233"];
    [app.buttons[@"OK"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:finishButton handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:creditCardCell handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
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
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:secureTextField handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [secureTextField enterText:@"112233"];
    [app.buttons[@"OK"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:finishButton handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [finishButton tap];
}

- (void)twoClickFollowing:(XCUIApplication *)app {
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    [app.tables.staticTexts[@"Normal Payment"] tap];
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay with Visa, MasterCard, or JCB"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:creditCardCell handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [creditCardCell tap];
    
    XCUIElement *saveCardCell = app.collectionViews.staticTexts[@"4811 11XX XXXX 1114 "];
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:saveCardCell handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [saveCardCell tap];
    
    XCUIElement *cvvNumberSecureTextField = other.secureTextFields[@"CVV NUMBER"];
    [cvvNumberSecureTextField enterText:@"123"];
    
    [app.buttons[@"Done"] tap];
    [app.buttons[@"Finish Payment"] tap];
    
    XCUIElement *secureTextField = app.secureTextFields[@"112233"];
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:secureTextField handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [secureTextField enterText:@"112233"];
    [app.buttons[@"OK"] tap];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:finishButton handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    [finishButton tap];
}

@end
