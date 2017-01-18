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
    XCUIElementQuery *cardPaymentOptionsElementsQuery = [scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"Card Payment Options"];
    XCUIElement *firstNameTextField = [[[cardPaymentOptionsElementsQuery childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"First Name"] elementBoundByIndex:0];
    [firstNameTextField clearAndEnterText:@"Nanang"];
    
    XCUIElement *lastNameTextField = [[[cardPaymentOptionsElementsQuery childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"Last Name"] elementBoundByIndex:0];
    [lastNameTextField clearAndEnterText:@"Rafsanjani"];
    
    XCUIElement *emailTextField = scrollViewsQuery.otherElements.textFields[@"Email"];
    [emailTextField clearAndEnterText:@"jukiginanjar@rafsanjani.com"];
    
    XCUIElement *phoneTextField = [[[cardPaymentOptionsElementsQuery childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"Phone"] elementBoundByIndex:0];
    [phoneTextField clearAndEnterText:@"08985999286"];
    [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element swipeUp];
}

@end
