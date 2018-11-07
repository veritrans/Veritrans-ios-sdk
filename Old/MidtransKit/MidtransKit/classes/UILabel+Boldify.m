//
//  UILabel+Boldify.m
//  MidtransKit
//
//  Created by Vanbungkring on 4/17/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "UILabel+Boldify.h"

@implementation UILabel (Boldify)
- (void)boldRange:(NSRange)range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    self.attributedText = attributedText;
}

- (void)boldSubstring:(NSString*)substring {
    if (!substring) return;
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}
@end
