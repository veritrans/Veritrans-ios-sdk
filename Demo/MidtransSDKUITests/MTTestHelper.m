//
//  MTTestHelper.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/23/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MTTestHelper.h"

@implementation XCTestCase (Utils)

- (void)waitUntilAvailableForElement:(XCUIElement *)element {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:predicate evaluatedWithObject:element handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

@end

@implementation XCUIElement (Utils)

- (void)enterText:(NSString *)text {
    if ([self.value length]) {
        return;
    }
    else {
        [self tap];
        [self typeText:text];
    }
    
    //    if ([self.value isKindOfClass:[NSString class]]) {
    //        NSString *stringValue = self.value;
    //        NSMutableString *deleteString = [NSMutableString new];
    //        for (int i=0; i<stringValue.length; i++) {
    //            [deleteString insertString:XCUIKeyboardKeyDelete atIndex:i];
    //        }
    //
    //        [self typeText:deleteString];
    
}

@end


@implementation MTTestHelper

+ (void)configureRequiredData:(XCUIApplication *)app {
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *other = scrollViewsQuery.otherElements;
    
    XCUIElement *settingButton = app.navigationBars[@"Cart"].buttons[@"Setting"];
    [settingButton tap];
    
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

@end
