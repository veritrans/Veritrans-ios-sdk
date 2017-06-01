//
//  VTGuideCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTGuideCell.h"
#import "VTClassHelper.h"
#import "VTKITConstant.h"
#import "VTTapableLabel.h"
@interface VTGuideCell()
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *illustrationView;
@property (strong, nonatomic) IBOutlet VTTapableLabel *contentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *illustrationWidth;

@end

@implementation VTGuideCell

- (void)setInstruction:(VTInstruction *)instruction number:(NSInteger)number {
    self.numberLabel.text = [NSString stringWithFormat:@"%li", (long)number];
    if ([[instruction.content stringsBetween:@"‘" and:@"’"] count] > 0) {
        NSString *boldLabel = [[instruction.content stringsBetween:@"‘" and:@"’"] firstObject];
        NSString *cleanString = [[instruction.content stringByReplacingOccurrencesOfString:@"‘" withString:@""] stringByReplacingOccurrencesOfString:@"’" withString:@""];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:cleanString];
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                           range:[attrString.string rangeOfString:boldLabel]];
        
        [attrString endEditing];
        self.contentLabel.attributedText = attrString;
    }
    
    else if ([instruction.content containsString:@"To BNI Account then Add New Account"]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                           range:[attrString.string rangeOfString:@"To BNI Account then Add New Account"]];
        
        [attrString endEditing];
        self.contentLabel.attributedText = attrString;
    }
    
   else  if ([instruction.content containsString:@"To BNI Account"]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                           range:[attrString.string rangeOfString:@"To BNI Account"]];
        
        [attrString endEditing];
        self.contentLabel.attributedText = attrString;
    }
   else  if ([instruction.content containsString:@"Proceed"]) {
       NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
       [attrString beginEditing];
       [attrString addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                          range:[attrString.string rangeOfString:@"Proceed"]];
       
       [attrString endEditing];
       self.contentLabel.attributedText = attrString;
   }
   else  if ([instruction.content containsString:@"Enter"]) {
       NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
       [attrString beginEditing];
       [attrString addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                          range:[attrString.string rangeOfString:@"Enter"]];
       
       [attrString endEditing];
       self.contentLabel.attributedText = attrString;
   }
   else  if ([instruction.content containsString:@"Set Destination Account"]) {
       NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
       [attrString beginEditing];
       [attrString addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                          range:[attrString.string rangeOfString:@"Set Destination Account"]];
       
       [attrString endEditing];
       self.contentLabel.attributedText = attrString;
   }
   else  if ([instruction.content containsString:@"Set Destination Account"]) {
       NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
       [attrString beginEditing];
       [attrString addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                          range:[attrString.string rangeOfString:@"Set Destination Account"]];
       
       [attrString endEditing];
       self.contentLabel.attributedText = attrString;
   }
   else  if ([instruction.content containsString:@"Add Destination Account"]) {
       NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
       [attrString beginEditing];
       [attrString addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                          range:[attrString.string rangeOfString:@"Add Destination Account"]];
       
       [attrString endEditing];
       self.contentLabel.attributedText = attrString;
   }
    else if ([instruction.content containsString:@"Correct"]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                           range:[attrString.string rangeOfString:@"Correct"]];
        
        [attrString endEditing];
        self.contentLabel.attributedText = attrString;
    }
    else if ([instruction.content containsString:@"Transfer"]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                           range:[attrString.string rangeOfString:@"Transfer"]];
        
        [attrString endEditing];
        self.contentLabel.attributedText = attrString;
    }
    else if ([instruction.content containsString:@"Connect"]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                           range:[attrString.string rangeOfString:@"Connect"]];
        
        [attrString endEditing];
        self.contentLabel.attributedText = attrString;
    }

    else if ([instruction.content containsString:@"Transfer to BNI Account"]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:instruction.content];
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                           range:[attrString.string rangeOfString:@"Transfer to BNI Account"]];
        
        [attrString endEditing];
        self.contentLabel.attributedText = attrString;
    }

    else {
        self.contentLabel.tapableText = instruction.content;
    }
    
    UIImage *image = [UIImage imageNamed:instruction.image inBundle:VTBundle compatibleWithTraitCollection:nil];
    if (image) {
        self.illustrationView.image = image;
        self.illustrationWidth.constant = image.size.width + 13;
    }
    else {
        self.illustrationView.image = nil;
        self.illustrationWidth.constant = 0;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
