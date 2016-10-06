//
//  VTStringHelper.h
//  MidtransKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidtransUIStringHelper : NSObject
+ (NSString *)emptyString;
+ (NSMutableAttributedString *)indentText:(NSAttributedString *)attributedString;
+ (NSMutableAttributedString *)indentTextWithDefaultStyle:(NSAttributedString *)attributedString;
+ (NSMutableAttributedString *)numberingTextWithList:(NSArray *)list;
+ (NSMutableAttributedString *)numberingTextWithFromListFile:(NSString *)filePath;
+ (NSMutableAttributedString *)numberingTextWithLocalizedStringPath:(NSString *)localizedString objectAtIndex:(NSInteger *)integer;
+ (NSMutableAttributedString *)numberingTextWithLocalizedStringPath:(NSArray *)localizedString;

@end
