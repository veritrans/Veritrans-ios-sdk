//
//  VTTheme.h
//  MidtransKit
//
//  Created by Arie on 7/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransUITheme : NSObject

+ (MidtransUITheme *_Nonnull)defaultTheme;
/**
 *  set primary background color, will use it as primary color scheme;
 */
@property(nonatomic, copy, null_resettable)UIColor *primaryBackgroundColor;
/**
 *  set primary background color, will use it as primary color scheme;
 */
@property(nonatomic, copy, null_resettable)UIColor *secondaryBackgroundColor;
/**
 *  set default font for theme
 */
@property(nonatomic, copy, null_resettable)UIFont  *font;
@property(nonatomic, copy, null_resettable)UIFont  *smallFont;
@property(nonatomic, copy, null_resettable)UIFont  *largeFont;
@property(nonatomic, copy, null_resettable)UIColor *errorColor;
@property(nonatomic, copy, null_resettable)UIColor *themeColor;
@property(nonatomic, copy, null_resettable)UIImage *logo;
@end
