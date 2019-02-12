//
//  MidtransUITextField.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/24/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUITextField.h"
#import "NSString+TextDirectionality.h"
#import "MidtransUIThemeManager.h"

@interface MidtransSmallButton : UIButton
@end

@implementation MidtransSmallButton
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    CGFloat widthDelta = (44. - bounds.size.width) > 0 ? (44. - bounds.size.width) : 0;
    CGFloat heightDelta = (44. - bounds.size.height) > 0 ? (44. - bounds.size.height) : 0;
    bounds = CGRectInset(bounds, -(widthDelta/2.), -(heightDelta/2.));
    return CGRectContainsPoint(bounds, point);
}
@end

static CGFloat const kFloatingLabelShowAnimationDuration = 0.17f;
static CGFloat const kFloatingLabelHideAnimationDuration = 0.17f;
static CGFloat const kInfoPadding = 5;

@interface MidtransUITextField()
@property (nonatomic) MidtransSmallButton *info1Button;
@property (nonatomic) MidtransSmallButton *info2Button;
@property (nonatomic) MidtransSmallButton *info3Button;
@end

@implementation MidtransUITextField {
    BOOL _isFloatingLabelFontDefault;
    UILabel *_warningLabel;
    UIView *_divView;
}

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)initInfoButton:(MidtransSmallButton *)button {
    [self addSubview:button];
    [button addTarget:self action:@selector(infoPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)infoPressed:(MidtransSmallButton *)sender {
    if ([sender isEqual:self.info1Button]) {
        if ([self.delegate respondsToSelector:@selector(textField_didInfo1Tap:)]) {
            [self.delegate textField_didInfo1Tap:self];
        }
    }
    else if ([sender isEqual:self.info2Button]) {
        if ([self.delegate respondsToSelector:@selector(textField_didInfo2Tap:)]) {
            [self.delegate textField_didInfo2Tap:self];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(textField_didInfo3Tap:)]) {
            [self.delegate textField_didInfo3Tap:self];
        }
    }
}

- (void)commonInit {
    self.accessibilityIdentifier = @"mt_textfield";
    
    self.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:self.font.pointSize];
    
    self.floatingLabelActiveTextColor = [[MidtransUIThemeManager shared] themeColor];
    
    self.info1Button = [MidtransSmallButton new];
    self.info2Button = [MidtransSmallButton new];
    self.info3Button = [MidtransSmallButton new];
    
    [self initInfoButton:self.info1Button];
    [self initInfoButton:self.info2Button];
    [self initInfoButton:self.info3Button];
    
    _divView = [UIView new];
    [self addSubview:_divView];
    
    _warningLabel = [UILabel new];
    _warningLabel.alpha = 0.0f;
    [self addSubview:_warningLabel];
    
    _floatingLabel = [UILabel new];
    _floatingLabel.alpha = 0.0f;
    [self addSubview:_floatingLabel];
    
    // some basic default fonts/colors
    self.floatingLabelFont = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:12];
    _floatingLabel.font = self.floatingLabelFont;
    _floatingLabelTextColor = [UIColor grayColor];
    _floatingLabel.textColor = _floatingLabelTextColor;
    _animateEvenIfNotFirstResponder = NO;
    _floatingLabelShowAnimationDuration = kFloatingLabelShowAnimationDuration;
    _floatingLabelHideAnimationDuration = kFloatingLabelHideAnimationDuration;
    [self setFloatingLabelText:self.placeholder];
    
    _warningLabel.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:10];
    _warningLabel.textColor = [UIColor redColor];
    
    _adjustsClearButtonRect = YES;
    _isFloatingLabelFontDefault = YES;
}

#pragma mark -

- (void)setWarning:(NSString *)warning {
    _warning = warning;
    [self setNeedsLayout];
}

- (UIFont *)defaultFloatingLabelFont {
    UIFont *textFieldFont = nil;
    
    if (!textFieldFont && self.attributedPlaceholder && self.attributedPlaceholder.length > 0) {
        textFieldFont = [self.attributedPlaceholder attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    if (!textFieldFont && self.attributedText && self.attributedText.length > 0) {
        textFieldFont = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    if (!textFieldFont) {
        textFieldFont = self.font;
    }
    
    return [UIFont fontWithName:textFieldFont.fontName size:roundf(textFieldFont.pointSize * 0.7f)];
}

- (void)updateDefaultFloatingLabelFont {
    UIFont *derivedFont = [self defaultFloatingLabelFont];
    
    if (_isFloatingLabelFontDefault) {
        self.floatingLabelFont = derivedFont;
    }
    else {
        // dont apply to the label, just store for future use where floatingLabelFont may be reset to nil
        self.floatingLabelFont = derivedFont;
    }
}

- (UIColor *)labelActiveColor {
    if (_floatingLabelActiveTextColor) {
        return _floatingLabelActiveTextColor;
    }
    else if ([self respondsToSelector:@selector(tintColor)]) {
        return [self performSelector:@selector(tintColor)];
    }
    return [UIColor blueColor];
}

- (void)setFloatingLabelFont:(UIFont *)floatingLabelFont {
    _floatingLabelFont = floatingLabelFont;
    _floatingLabel.font = _floatingLabelFont ? _floatingLabelFont : [self defaultFloatingLabelFont];
    _isFloatingLabelFontDefault = floatingLabelFont == nil;
    [self setFloatingLabelText:self.placeholder];
    [self invalidateIntrinsicContentSize];
}

- (void)showWarningLabel:(BOOL)animated {
    _warningLabel.text = _warning;
    
    void (^showBlock)() = ^{
        _warningLabel.alpha = 1.0;
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelShowAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else {
        showBlock();
    }
}

- (void)hideWarningLabel:(BOOL)animated {
    void (^hideBlock)() = ^{
        _warningLabel.alpha = 0.0f;
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelHideAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
    }
    else {
        hideBlock();
    }
}

- (void)showFloatingLabel:(BOOL)animated {
    void (^showBlock)() = ^{
        _floatingLabel.alpha = 1.0f;
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelShowAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else {
        showBlock();
    }
}

- (void)hideFloatingLabel:(BOOL)animated {
    void (^hideBlock)() = ^{
        _floatingLabel.alpha = 0.0f;
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelHideAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
    }
    else {
        hideBlock();
    }
}

- (void)setLabelOriginForTextAlignment {
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    CGFloat originX = textRect.origin.x;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        originX = textRect.origin.x + (textRect.size.width/2) - (_floatingLabel.frame.size.width/2);
    }
    else if (self.textAlignment == NSTextAlignmentRight) {
        originX = textRect.origin.x + textRect.size.width - _floatingLabel.frame.size.width;
    }
    else if (self.textAlignment == NSTextAlignmentNatural) {
        JVTextDirection baseDirection = [_floatingLabel.text getBaseDirection];
        if (baseDirection == JVTextDirectionRightToLeft) {
            originX = textRect.origin.x + textRect.size.width - _floatingLabel.frame.size.width;
        }
    }
    
    _floatingLabel.frame = CGRectMake(originX, _floatingLabel.frame.origin.y,
                                      _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
}

- (void)setFloatingLabelText:(NSString *)text {
    _floatingLabel.text = text;
    [self setNeedsLayout];
}

#pragma mark - UITextField

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self updateDefaultFloatingLabelFont];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self updateDefaultFloatingLabelFont];
}

- (CGSize)intrinsicContentSize {
    CGSize textFieldIntrinsicContentSize = [super intrinsicContentSize];
    [_floatingLabel sizeToFit];
    return CGSizeMake(textFieldIntrinsicContentSize.width,
                      textFieldIntrinsicContentSize.height + _floatingLabelYPadding + _floatingLabel.bounds.size.height);
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self setFloatingLabelText:placeholder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    [super setAttributedPlaceholder:attributedPlaceholder];
    [self setFloatingLabelText:attributedPlaceholder.string];
    [self updateDefaultFloatingLabelFont];
}

- (void)setPlaceholder:(NSString *)placeholder floatingTitle:(NSString *)floatingTitle {
    [super setPlaceholder:placeholder];
    [self setFloatingLabelText:floatingTitle];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    rect = [self insetRectForBounds:rect];
    return CGRectIntegral(rect);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    rect = [self insetRectForBounds:rect];
    return CGRectIntegral(rect);
}

- (CGRect)insetRectForBounds:(CGRect)rect {
    CGFloat info1Width = CGRectGetWidth([self info1IconRect]) > 0 ? CGRectGetWidth([self info1IconRect])+kInfoPadding : 0;
    CGFloat info2Width = CGRectGetWidth([self info2IconRect]) > 0 ? CGRectGetWidth([self info2IconRect])+kInfoPadding : 0;
    CGFloat info3Width = CGRectGetWidth([self info3IconRect]) > 0 ? CGRectGetWidth([self info3IconRect])+kInfoPadding : 0;
    CGFloat rightPadding = info1Width+info2Width+info3Width;
    return CGRectMake(0, 15, rect.size.width-rightPadding, rect.size.height-30);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect rect = [super clearButtonRectForBounds:bounds];
    return CGRectIntegral(rect);
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setLabelOriginForTextAlignment];
    
    BOOL firstResponder = self.isFirstResponder;
    _floatingLabel.textColor = (firstResponder && self.text && self.text.length > 0 ?
                                self.labelActiveColor : self.floatingLabelTextColor);
    if (!self.text || 0 == [self.text length]) {
        [self hideFloatingLabel:firstResponder];
    } else {
        [self showFloatingLabel:firstResponder];
    }
    
    if ([_warning length]) {
        [self showWarningLabel:YES];
        _divView.backgroundColor = [UIColor redColor];
    } else {
        [self hideWarningLabel:YES];
        _divView.backgroundColor = [UIColor colorWithRed:200/255.0f
                                                   green:200/255.0f
                                                    blue:204/255.0f
                                                   alpha:1.0f];
    }
    
    self.info1Button.frame = [self info1IconRect];
    self.info2Button.frame = [self info2IconRect];
    self.info3Button.frame = [self info3IconRect];
    
    [self.info1Button setBackgroundImage:self.info1Icon forState:UIControlStateNormal];
    [self.info2Button setBackgroundImage:self.info2Icon forState:UIControlStateNormal];
    [self.info3Button setBackgroundImage:self.info3Icon forState:UIControlStateNormal];
    
    _warningLabel.frame = [self warningLabelRect];
    
    _divView.frame = [self divViewRect];
    _divView.hidden = !_underlined;
    
    _floatingLabel.frame = [self floatingLabelRect];
}

- (CGRect)floatingLabelRect {
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), 15);
}

- (CGRect)divViewRect {
    return CGRectMake(0, CGRectGetMaxY([self textRectForBounds:self.bounds]), CGRectGetWidth(self.bounds), 1.);
}

- (CGRect)warningLabelRect {
    return CGRectMake(0, CGRectGetMaxY([self divViewRect]), CGRectGetWidth(self.bounds), 15);
}
- (CGRect)info1IconRect {
    CGSize size = _info1Icon.size;
    CGFloat width = _info1Icon ? size.width : 0;
    CGRect fieldRect = self.bounds;
    return CGRectMake(CGRectGetMaxX(fieldRect)-size.width, CGRectGetMidY(fieldRect)-(size.height/2.0), width, size.height);
}
- (CGRect)info2IconRect {
    CGSize size = _info2Icon.size;
    CGFloat width = _info2Icon ? size.width : 0;
    CGRect fieldRect = self.bounds;
    
    CGFloat info1Width = CGRectGetWidth([self info1IconRect]) > 0 ? CGRectGetWidth([self info1IconRect])+kInfoPadding : 0;
    
    return CGRectMake(CGRectGetMaxX(fieldRect)-(info1Width + size.width),
                      CGRectGetMidY(fieldRect)-(size.height/2.0),
                      width,
                      size.height);
}
- (CGRect)info3IconRect {
    CGSize size = _info3Icon.size;
    CGFloat width = _info3Icon ? size.width : 0;
    CGRect fieldRect = self.bounds;
    
    CGFloat info1Width = CGRectGetWidth([self info1IconRect]) > 0 ? CGRectGetWidth([self info1IconRect])+kInfoPadding : 0;
    CGFloat info2Width = CGRectGetWidth([self info2IconRect]) > 0 ? CGRectGetWidth([self info2IconRect])+kInfoPadding : 0;
    
    return CGRectMake(CGRectGetMaxX(fieldRect) - (info1Width + info2Width + size.width),
                      CGRectGetMidY(fieldRect)-(size.height/2.0),
                      width,
                      size.height);
}

@end
