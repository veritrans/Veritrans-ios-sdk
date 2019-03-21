//
//  VTTapableLabel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 4/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "VTTapableLabel.h"
#import "VTClassHelper.h"
#import "MidtransUIThemeManager.h"

@interface NSString (utils)
@end

@implementation NSString (utils)
- (NSArray *)stringsBetween:(NSString *)string1 and:(NSString *)string2 {
    NSString *pattern = [NSString stringWithFormat:@"%@(.*?)%@", string1, string2];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSMutableArray *stringResult = [NSMutableArray new];
    [regex enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSLog(@"match: %@", [self substringWithRange:[result range]]);
        [stringResult addObject:[self substringWithRange:[result rangeAtIndex:1]]];
    }];
    return stringResult;
}
@end

@interface VTTapableLabel()
@property (nonatomic) NSLayoutManager *layoutManager;
@property (nonatomic) NSTextContainer *textContainer;
@property (nonatomic) NSTextStorage *textStorage;
@property (nonatomic) NSArray<NSString*> *linkStrings;
@end

@implementation VTTapableLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    
    self.textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.lineBreakMode = self.lineBreakMode;
    self.textContainer.maximumNumberOfLines = self.numberOfLines;
    
    self.layoutManager = [NSLayoutManager new];
    [self.layoutManager addTextContainer:self.textContainer];
    
    self.textStorage = [NSTextStorage new];
    [self.textStorage addLayoutManager:self.layoutManager];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textContainer.size = self.bounds.size;
}

- (void)setTapableText:(NSString *)tapableText {
    _tapableText = tapableText;
    
    if (tapableText.length == 0) return;
    
    NSString *cleanedText = [tapableText stringByReplacingOccurrencesOfString:@"<link>" withString:@""];
    cleanedText = [cleanedText stringByReplacingOccurrencesOfString:@"</link>" withString:@""];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:cleanedText];
    
    self.linkStrings = [tapableText stringsBetween:@"<link>" and:@"</link>"];
    if (self.linkStrings.count) {
        NSDictionary *attr = @{NSForegroundColorAttributeName:[[MidtransUIThemeManager shared] themeColor]};
        for (NSString *string in self.linkStrings) {
            NSRange range = [cleanedText rangeOfString:string];
            [attrString addAttributes:attr range:range];
        }
    }
    
    [attrString replaceCharacterString:@"[token_button]"
                              withIcon:[UIImage imageNamed:@"TokenButtonIcon" inBundle:VTBundle compatibleWithTraitCollection:nil]];
    
    [self.textStorage setAttributedString:attrString];
    
    self.attributedText = attrString;
}

- (void)handleTap:(UIGestureRecognizer *)sender {
    CGPoint locationOfTouch = [sender locationInView:sender.view];
    NSInteger indexOfCharacter = [self.layoutManager characterIndexForPoint:locationOfTouch inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:nil];
    for (NSString *string in self.linkStrings) {
        NSRange range = [self.attributedText.string rangeOfString:string];
        if (NSLocationInRange(indexOfCharacter, range)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:VTTapableLabelDidTapLink object:string];
        }
    }
}

@end
