//
//  VTStringHelper.h
//  MidtransKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTStringHelper : NSObject
+ (NSString *)emptyString;
+ (NSMutableAttributedString *)indentText:(NSAttributedString *)attributedString;
+ (NSMutableAttributedString *)indentTextWithDefaultStyle:(NSAttributedString *)attributedString;
+ (NSMutableAttributedString *)numberingTextWithLocalizedStringPath:(NSString *)localizedString;

@end
