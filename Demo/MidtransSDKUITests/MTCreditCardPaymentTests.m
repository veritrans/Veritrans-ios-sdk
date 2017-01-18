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

- (void)testCCNormalTransaction {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"Cart"].buttons[@"Setting"] tap];
    
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    [other.buttons[@"Normal"] tap];
    
    XCUIElement *secure3dSwitch = [[other childrenMatchingType:XCUIElementTypeSwitch] elementBoundByIndex:0];
    if ([secure3dSwitch.value isEqualToString:@"0"]) {
        [secure3dSwitch tap];
    }
    
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

@end
