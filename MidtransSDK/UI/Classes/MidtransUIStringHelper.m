//
//  VTStringHelper.m
//  MidtransKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIStringHelper.h"
#import <UIKit/UIKit.h>
#import "MidtransUIThemeManager.h"
#import "VTClassHelper.h"



@implementation MidtransUIStringHelper

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
                                    value:[[MidtransUIThemeManager shared].themeFont fontRegularWithSize:15]
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
    [mutableAttributedString replaceCharacterString:@"[token_button]" withIcon:[UIImage imageNamed:@"TokenButtonIcon" inBundle:VTBundle compatibleWithTraitCollection:nil]];
    
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
    [mutableAttributedString replaceCharacterString:@"[token_button]" withIcon:[UIImage imageNamed:@"TokenButtonIcon" inBundle:VTBundle compatibleWithTraitCollection:nil]];
    return mutableAttributedString;
}
@end
