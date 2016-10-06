//
//  MidtransUITextField.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/24/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransUITextField : UITextField
@property (nonatomic, strong, readonly) UILabel * floatingLabel;
@property (nonatomic) IBInspectable BOOL underlined;
@property (nonatomic) IBInspectable NSString *warning;
@property (nonatomic) IBInspectable CGFloat floatingLabelYPadding;
@property (nonatomic) IBInspectable CGFloat floatingLabelXPadding;
@property (nonatomic) IBInspectable CGFloat placeholderYPadding;
@property (nonatomic) IBInspectable CGFloat textRightPadding;
@property (nonatomic, strong) UIFont * floatingLabelFont;
@property (nonatomic, strong) IBInspectable UIColor * floatingLabelTextColor;
@property (nonatomic, strong) IBInspectable UIColor * floatingLabelActiveTextColor;
@property (nonatomic, assign) IBInspectable BOOL animateEvenIfNotFirstResponder;
@property (nonatomic, assign) NSTimeInterval floatingLabelShowAnimationDuration;
@property (nonatomic, assign) NSTimeInterval floatingLabelHideAnimationDuration;
@property (nonatomic, assign) IBInspectable BOOL adjustsClearButtonRect;
@property (nonatomic, assign) IBInspectable BOOL keepBaseline;
@property (nonatomic) UIImage *infoIcon;

- (void)setPlaceholder:(NSString *)placeholder floatingTitle:(NSString *)floatingTitle;

@end
