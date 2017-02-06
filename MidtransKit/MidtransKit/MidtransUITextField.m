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

static CGFloat const kFloatingLabelShowAnimationDuration = 0.17f;
static CGFloat const kFloatingLabelHideAnimationDuration = 0.17f;
static CGFloat const kInfoPadding = 5;

@implementation MidtransUITextField {
    BOOL _isFloatingLabelFontDefault;
    
    UILabel *_warningLabel;
    UIView *_divView;
    UIImageView *_info1View;
    UIImageView *_info2View;
    UIImageView *_info3View;
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

- (void)addTapGestureToInfoView:(UIImageView *)infoView {
    infoView.userInteractionEnabled = YES;
    [infoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoTapped:)]];
}

- (void)infoTapped:(UIGestureRecognizer *)sender {
    if ([sender.view isEqual:_info1View]) {
        if ([self.delegate respondsToSelector:@selector(textField_didInfo1Tap:)]) {
            [self.delegate textField_didInfo1Tap:self];
        }
    }
    else if ([sender.view isEqual:_info1View]) {
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
    
    self.font = [[MidtransUIThemeManager shared].themeFont fontRegularWithSize:self.font.pointSize];
    
    self.floatingLabelActiveTextColor = [[MidtransUIThemeManager shared] themeColor];
    
    _info1View = [UIImageView new];
    [self addSubview:_info1View];
    _info2View = [UIImageView new];
    [self addSubview:_info2View];
    _info3View = [UIImageView new];
    [self addSubview:_info3View];
    
    [self addTapGestureToInfoView:_info1View];
    [self addTapGestureToInfoView:_info2View];
    [self addTapGestureToInfoView:_info3View];
    
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
    CGFloat rightPadding = CGRectGetWidth([self info1IconRect])+CGRectGetWidth([self info2IconRect])+CGRectGetWidth([self info3IconRect]);
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
    
    _info1View.frame = [self info1IconRect];
    _info2View.frame = [self info2IconRect];
    _info3View.frame = [self info3IconRect];
    
    _info1View.image = _info1Icon;
    _info2View.image = _info2Icon;
    _info3View.image = _info3Icon;
    
    _warningLabel.frame = [self warningLabelRect];
    
    _divView.frame = [self divViewRect];
    _divView.hidden = !_underlined;
    
    _floatingLabel.frame = [self floatingLabelRect];
}

- (CGRect)floatingLabelRect {
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), 15);
}

- (CGRect)divViewRect {
    return CGRectMake(0, CGRectGetMaxY([self textRectForBounds:self.bounds])+3, CGRectGetWidth(self.bounds), 1.);
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
