//
//  XCUIElement+Textfield.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 1/16/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "XCUIElement+Textfield.h"

@implementation XCUIElement (Textfield)

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
