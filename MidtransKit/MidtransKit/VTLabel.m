//
//  VTLabel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTLabel.h"
#import "VTClassHelper.h"

@implementation VTLabel

- (void)setVtText:(NSString *)vtText {
    _vtText = vtText;
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"TokenButtonIcon" inBundle:VTBundle compatibleWithTraitCollection:nil];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:vtText];
    NSRange foundRange = [vtText rangeOfString:@"*"];
    
    while (foundRange.location != NSNotFound) {
        [att replaceCharactersInRange:foundRange withAttributedString:attachmentString];
        
        NSRange rangeToSearch;
        rangeToSearch.location = foundRange.location + foundRange.length;
        rangeToSearch.length = vtText.length - rangeToSearch.location;
        foundRange = [vtText rangeOfString:@"*" options:0 range:rangeToSearch];
    }
    
    [self setAttributedText:att];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
