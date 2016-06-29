//
//  VTStringHelper.m
//  MidtransKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTStringHelper.h"
#import <UIKit/UIKit.h>
#import "VTThemeManager.h"
#import "VTClassHelper.h"

@interface NSMutableAttributedString (Helper)
@end
@implementation NSMutableAttributedString (Helper)

- (void)replaceCharacterString:(NSString *)characterString withIcon:(UIImage *)icon {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = icon;
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSString *string = self.string;
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

@implementation VTStringHelper

+ (NSString *)emptyString {
    return @"";
}

+ (NSMutableAttributedString *)indentText:(NSAttributedString *)attributedString {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.lineSpacing = 2.0f;
    paragrahStyle.paragraphSpacing = 5.0f;
    paragrahStyle.paragraphSpacingBefore = 2.0f;
    paragrahStyle.firstLineHeadIndent = 0.0f;  // First line is the one with bullet point
    paragrahStyle.headIndent = 28.0f;    // Set the indent for given bullet character and size font
    [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle
                                    range:NSMakeRange(0, attributedString.length)];
    return mutableAttributedString;
}

+ (NSMutableAttributedString *)indentTextWithDefaultStyle:(NSAttributedString *)attributedString {
    NSMutableAttributedString *mutableAttributedString = [self indentText:attributedString];
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[[VTThemeManager shared] regularFontWithSize:15]
                                    range:NSMakeRange(0, attributedString.length)];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor darkGrayColor]
                                    range:NSMakeRange(0, attributedString.length)];
    return mutableAttributedString;
}

+ (NSMutableAttributedString *)numberingTextWithList:(NSArray *)list {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i <= list.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%@", list[i-1]];
        [points addObject:[NSString stringWithFormat:@"%ld.\t%@", (long)i, NSLocalizedString(key, nil)]];
    }
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[points componentsJoinedByString:@"\n"]];
    mutableAttributedString = [self indentTextWithDefaultStyle:mutableAttributedString];
    [mutableAttributedString replaceCharacterString:@"*" withIcon:[UIImage imageNamed:@"TokenButtonIcon" inBundle:VTBundle compatibleWithTraitCollection:nil]];
    return mutableAttributedString;
}

+ (NSMutableAttributedString *)numberingTextWithFromListFile:(NSString *)filePath {
    NSArray *list = [NSArray arrayWithContentsOfFile:filePath];
    return [self numberingTextWithLocalizedStringPath:list];
}

+ (NSMutableAttributedString *)numberingTextWithLocalizedStringPath:(NSString *)localizedString objectAtIndex:(NSInteger *)integer {
    NSString *filePath = [VTBundle pathForResource:localizedString ofType:@"plist"];
    return [self numberingTextWithFromListFile:filePath];
}

+ (NSMutableAttributedString *)numberingTextWithLocalizedStringPath:(NSArray *)localizedString {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i <= localizedString.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%@", localizedString[i-1]];
        [points addObject:[NSString stringWithFormat:@"%ld.\t%@", (long)i, NSLocalizedString(key, nil)]];
    }
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[points componentsJoinedByString:@"\n"]];
    mutableAttributedString = [self indentTextWithDefaultStyle:mutableAttributedString];
    [mutableAttributedString replaceCharacterString:@"*" withIcon:[UIImage imageNamed:@"TokenButtonIcon" inBundle:VTBundle compatibleWithTraitCollection:nil]];
    return mutableAttributedString;
}
@end
