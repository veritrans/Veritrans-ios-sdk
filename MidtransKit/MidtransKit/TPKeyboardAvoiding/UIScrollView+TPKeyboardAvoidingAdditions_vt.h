//
//  UIScrollView+TPKeyboardAvoidingAdditions_vt.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 4/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (TPKeyboardAvoidingAdditions_vt)
- (BOOL)TPKeyboardAvoiding_focusNextTextField;
- (void)TPKeyboardAvoiding_scrollToActiveTextField;

- (void)TPKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification;
- (void)TPKeyboardAvoiding_keyboardWillHide:(NSNotification*)notification;
- (void)TPKeyboardAvoiding_updateContentInset;
- (void)TPKeyboardAvoiding_updateFromContentSizeChange;
- (void)TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView:(UIView*)view;
- (UIView*)TPKeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view;
-(CGSize)TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames;

@end
