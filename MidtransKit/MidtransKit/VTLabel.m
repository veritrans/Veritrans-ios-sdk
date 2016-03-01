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

- (void)awakeFromNib {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"TokenButtonIcon" inBundle:VTBundle compatibleWithTraitCollection:nil];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange foundRange = [self.text rangeOfString:@"*"];
    
    while (foundRange.location != NSNotFound) {
        [att replaceCharactersInRange:foundRange withAttributedString:attachmentString];
        
        NSRange rangeToSearch;
        rangeToSearch.location = foundRange.location + foundRange.length;
        rangeToSearch.length = self.text.length - rangeToSearch.location;
        foundRange = [self.text rangeOfString:@"*" options:0 range:rangeToSearch];
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
