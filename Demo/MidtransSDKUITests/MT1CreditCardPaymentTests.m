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
    
    [self setNormalCreditCardPaymentWithApp:app];
    
    [self enterCreditCardPaymentPageWithApp:app];
    
    [self inputCardNumber:@"4811111111111114" expDate:@"02 / 20" cvv:@"123" withApp:app];
    
    [app.buttons[@"Finish Payment"] tap];
    
    [self input3DSecureOTP:app];
    
    XCUIElement *finishButton = app.buttons[@"Finish"];
    [self waitUntilAvailableForElement:finishButton];
    [finishButton tap];
}

- (void)test2CCTwoClicksTransaction {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self twoClickInitial:app];
    
    [self twoClickFollowingWithInstallment:NO andApp:app];
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

- (void)test4OnlineInstallment {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self setNormalCreditCardPaymentWithApp:app];
    
    NSLog(@"[MANDIRI CARD TEST]");
    [self setAcquiringBank:@"Mandiri" withApp:app];
    [self enterCreditCardPaymentPageWithApp:app];
    [self inputCardNumber:@"4617006959746656" expDate:@"02 / 20" cvv:@"123" withApp:app];
    [self doInstallmentWith3DSEnabled:YES andApp:app];
    
    NSLog(@"[BNI CARD TEST]");
    [self setAcquiringBank:@"BNI" withApp:app];
    [self enterCreditCardPaymentPageWithApp:app];
    [self inputCardNumber:@"4105058689481467" expDate:@"02 / 20" cvv:@"123" withApp:app];
    [self doInstallmentWith3DSEnabled:YES andApp:app];
    
    NSLog(@"[BCA CARD TEST]");
    [self setAcquiringBank:@"BCA" withApp:app];
    [self enterCreditCardPaymentPageWithApp:app];
    [self inputCardNumber:@"4773776057051650" expDate:@"02 / 20" cvv:@"123" withApp:app];
    [self doInstallmentWith3DSEnabled:YES andApp:app];
    
    NSLog(@"[BRI CARD TEST]");
    [self setAcquiringBank:@"BRI" withApp:app];
    [self enterCreditCardPaymentPageWithApp:app];
    [self inputCardNumber:@"4365026335737199" expDate:@"02 / 20" cvv:@"123" withApp:app];
    [self doInstallmentWith3DSEnabled:YES andApp:app];
    
    NSLog(@"[MAYBANK CARD TEST]");
    [self setAcquiringBank:@"Maybank" withApp:app];
    [self enterCreditCardPaymentPageWithApp:app];
    [self inputCardNumber:@"4055772026036004" expDate:@"02 / 20" cvv:@"123" withApp:app];
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
    XCUIElement *installmentPlusButton = other.buttons[@"icon btn plus "];
    [installmentPlusButton tap];
    
    [app.buttons[@"Finish Payment"] tap];
    
    if (enable3ds) {
        [self input3DSecureOTP:app];
    }
    
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
    
    [app.buttons[@"Done"] tap];
}

- (void)input3DSecureOTP:(XCUIApplication *)app {
    XCUIElement *secureTextField = app.secureTextFields[@"112233"];
    [self waitUntilAvailableForElement:secureTextField];
    [secureTextField enterText:@"112233"];
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
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay with Visa, MasterCard, or JCB"];
    [self waitUntilAvailableForElement:creditCardCell];
    [creditCardCell tap];
    
    XCUIElement *saveCardCell = app.collectionViews.staticTexts[@"4811 11XX XXXX 1114 "];
    [self waitUntilAvailableForElement:saveCardCell];
    [saveCardCell tap];
    
    XCUIElement *cvvNumberSecureTextField = other.secureTextFields[@"CVV NUMBER"];
    [cvvNumberSecureTextField enterText:@"123"];
    
    [app.buttons[@"Done"] tap];
    
    if (withInstallment) {
        XCUIElement *installmentPlusButton = other.buttons[@"icon btn plus "];
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
    
    XCUIElement *creditCardCell = app.tables.staticTexts[@"Pay with Visa, MasterCard, or JCB"];
    [self waitUntilAvailableForElement:creditCardCell];
    
    [creditCardCell tap];
}

@end
