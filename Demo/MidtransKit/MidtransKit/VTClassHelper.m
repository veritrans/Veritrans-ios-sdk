//
//  VTClassHelper.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@implementation NSMutableAttributedString (Helper)

- (void)replaceCharacterString:(NSString *)characterString withIcon:(UIImage *)icon {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = icon;
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSString *string = self.string.copy;
    NSRange foundRange = [string rangeOfString:characterString];
    
    while (foundRange.location != NSNotFound) {
        [self replaceCharactersInRange:foundRange withAttributedString:attachmentString];
        
        NSRange rangeToSearch;
        rangeToSearch.location = foundRange.location + foundRange.length;
        rangeToSearch.length = string.length - rangeToSearch.location;
        foundRange = [string rangeOfString:characterString options:0 range:rangeToSearch];
    }
}

@end

@implementation NSNumber (formatter)

- (NSString *)formattedCurrencyNumber {
    NSNumberFormatter *nf = [NSNumberFormatter indonesianCurrencyFormatter];
    return [@"Rp " stringByAppendingString:[nf stringFromNumber:self]];
}

@end

@implementation VTClassHelper

+ (NSBundle*)kitBundle {
    static dispatch_once_t onceToken;
    static NSBundle *kitBundle = nil;
    dispatch_once(&onceToken, ^{
        //check if bundle is in dynamic framework
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks/MidtransKit.framework/MidtransKit"
                                                   withExtension:@"bundle"];
        if (!bundleURL) {
            bundleURL = [[NSBundle mainBundle] URLForResource:@"MidtransKit"
                                                withExtension:@"bundle"];
        }
        kitBundle = [NSBundle bundleWithURL:bundleURL];
        
    });
    return kitBundle;
}

+ (NSArray <VTInstruction *> *)instructionsFromFilePath:(NSString *)filePath {
    NSArray *guideList = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *instructions = [NSMutableArray new];
    for (NSDictionary *guideData in guideList) {
        VTInstruction *instruction = [VTInstruction modelObjectWithDictionary:guideData];
        [instructions addObject:instruction];
    }
    return instructions;
}

+ (NSArray <VTGroupedInstruction*>*)groupedInstructionsFromFilePath:(NSString *)filePath {
    NSArray *guideList = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *groupedInstructions = [NSMutableArray new];
    for (NSDictionary *groupedInstructionData in guideList) {
        VTGroupedInstruction *groupedIns = [VTGroupedInstruction modelObjectWithDictionary:groupedInstructionData];
        [groupedInstructions addObject:groupedIns];
    }
    return groupedInstructions;
}

+ (BOOL)hasKindOfController:(UIViewController *)controller onControllers:(NSArray<UIViewController*>*)controllers {
    for (UIViewController *c in controllers) {
        if ([c isKindOfClass:controller.class]) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation NSString (utilities)

- (BOOL)isNumeric {
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

- (NSString *)formattedCreditCardNumber {
    NSString *cardNumber = self;
    NSString *result = @"";
    
    while (cardNumber.length > 0) {
        NSString *subString = [cardNumber substringToIndex:MIN(cardNumber.length, 4)];
        result = [result stringByAppendingString:subString];
        if (subString.length == 4) {
            result = [result stringByAppendingString:@" "];
        }
        cardNumber = [cardNumber substringFromIndex:MIN(cardNumber.length, 4)];
    }
    return result;
}

- (CGSize)sizeWithFont:(UIFont *)font constraint:(CGSize)constraint {
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [self boundingRectWithSize:constraint
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

@end

@implementation UILabel (utilities)

- (void)setRoundedCorners:(BOOL)rounded {
    if (rounded) {
        self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2.0;
    } else {
        self.layer.cornerRadius = 0;
    }
}

@end

@implementation UIViewController (Utils)

- (void)addSubViewController:(UIViewController *)viewController toView:(UIView*)contentView {
    
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:viewController.view];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:0 metrics:0 views:@{@"content":viewController.view}]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[content]|" options:0 metrics:0 views:@{@"content":viewController.view}]];
}

- (void)removeSubViewController:(UIViewController *)viewController {
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    [viewController didMoveToParentViewController:nil];
}

@end


