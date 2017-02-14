//
//  MIDTestHelper.h
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/23/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface XCTestCase (Utils)
- (void)waitUntilAvailableForElement:(XCUIElement *)element;
@end

@interface XCUIElement (Utils)
- (void)enterText:(NSString *)text;
@end

@interface MIDTestHelper : NSObject
+ (void)configureRequiredData:(XCUIApplication *)app;
@end
