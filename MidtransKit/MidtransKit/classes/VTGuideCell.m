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

static NSString *const BANK_CODE_BNI = @"009";
static NSString *const BANK_CODE_BRI = @"002";
static NSString *const BANK_CODE_PERMATA = @"013";
static NSString *const BANK_BRI = @"BRI";
static NSString *const BANK_BNI = @"BNI";
static NSString *const BANK_PERMATA = @"Permata";
static NSString *const BANK_CODE_INSTRUCTION_PLACEHOLDER = @"[BANK_CODE]";
static NSString *const BANK_NAME_INSTRUCTION_PLACEHOLDER = @"[BANK_NAME]";

@interface VTGuideCell()
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *illustrationView;
@property (strong, nonatomic) IBOutlet VTTapableLabel *contentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *illustrationWidth;

@end

@implementation VTGuideCell

- (void)setInstruction:(VTInstruction *)instruction number:(NSInteger)number {
    self.numberLabel.text = [NSString stringWithFormat:@"%li.", (long)number];
    if ([[instruction.content stringsBetween:@"‘" and:@"’"] count]) {
        self.contentLabel.attributedText = [self applyBoldToStringFromContent:[self replacePlaceholderFromContent:instruction.content]];
    }
    else {
        self.contentLabel.tapableText = instruction.content;
    }
    [self setImageFromInstruction:instruction];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIImage *)setImageFromInstruction:(VTInstruction *)instruction {
    UIImage *image = [UIImage imageNamed:instruction.image inBundle:VTBundle compatibleWithTraitCollection:nil];
    if ([instruction.content containsString:BANK_NAME_INSTRUCTION_PLACEHOLDER] ||
        [instruction.content containsString:BANK_CODE_INSTRUCTION_PLACEHOLDER]) {
        if ([self.otherVaProcessor isEqualToString:MIDTRANS_PAYMENT_BRI_VA] ||
            [self.otherVaProcessor isEqualToString:MIDTRANS_PAYMENT_BNI_VA]) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",instruction.image, self.otherVaProcessor] inBundle:VTBundle compatibleWithTraitCollection:nil];
        }
    }
    if (image) {
        self.illustrationView.image = image;
        self.illustrationWidth.constant = image.size.width + 13;
    }
    else {
        self.illustrationView.image = nil;
        self.illustrationWidth.constant = 0;
    }
    return image;
}

- (NSString *)replacePlaceholderFromContent:(NSString *)content {
    NSString *filledString = [[content
                              stringByReplacingOccurrencesOfString:BANK_CODE_INSTRUCTION_PLACEHOLDER
                              withString:[self getBankCodeFromOtherVaProcessor:self.otherVaProcessor]]
                             stringByReplacingOccurrencesOfString:BANK_NAME_INSTRUCTION_PLACEHOLDER
                             withString:[self getBankNameFromOtherVaProcessor:self.otherVaProcessor]];
    return filledString;
}

- (NSAttributedString *)applyBoldToStringFromContent:(NSString *)content {
    NSMutableArray *boldLabelArray = [NSMutableArray arrayWithArray:[content stringsBetween:@"‘" and:@"’"]];
    NSString *cleanedString = [[content stringByReplacingOccurrencesOfString:@"‘" withString:@""] stringByReplacingOccurrencesOfString:@"’" withString:@""];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cleanedString];
    for (NSString *boldLabel in boldLabelArray){
        [attributedString beginEditing];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]
                                 range:[attributedString.string rangeOfString:boldLabel]];
        [attributedString endEditing];
    }
    return attributedString;
}

- (NSString *)getBankCodeFromOtherVaProcessor:(NSString*)processor {
    if([processor isEqualToString:MIDTRANS_PAYMENT_BNI_VA]){
        return BANK_CODE_BNI;
    }
    else if([processor isEqualToString:MIDTRANS_PAYMENT_BRI_VA]){
        return BANK_CODE_BRI;
    }
    else {
        return BANK_CODE_PERMATA;
    }
}

- (NSString *)getBankNameFromOtherVaProcessor:(NSString*)processor {
    if([processor isEqualToString:MIDTRANS_PAYMENT_BNI_VA]){
        return BANK_BNI;
    }
    else if([processor isEqualToString:MIDTRANS_PAYMENT_BRI_VA]){
        return BANK_BRI;
    }
    else {
        return BANK_PERMATA;
    }
}

- (void)adjustBackgroundColor:(NSInteger)number {
    if (number %2 == 0) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
