//
//  UIFont+IBCustomFonts.m
//  IBCustomFonts
//
//  Created by Deniss Fedotovs on 9/23/13.
//  https://github.com/deni2s/IBCustomFonts
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "MidtransUIThemeManager.h"
#import "MidtransUITheme.h"

const static NSString* IBCustomFontsKey = @"IBCustomFonts";

void standard_swizzle(Class cls, SEL original, SEL replacement) {
    Method originalMethod;
    if ((originalMethod = class_getClassMethod(cls, original))) { //selectors for classes take priority over instances should there be a -propertyName and +propertyName
        Method replacementMethod = class_getClassMethod(cls, replacement);
        method_exchangeImplementations(originalMethod, replacementMethod);  //because class methods are really just statics, there's no method hierarchy to preserve, so we can directly exchange IMPs
    } else {
        //get the replacement IMP
        //set the original IMP on the replacement selector
        //try to add the replacement IMP directly to the class on original selector
        //if it succeeds then we're all good (the original before was located on the superclass)
        //if it doesn't then that means an IMP is already there so we have to overwrite it
        IMP replacementImplementation = method_setImplementation(class_getInstanceMethod(cls, replacement), class_getMethodImplementation(cls, original));
        if (!class_addMethod(cls, original, replacementImplementation, method_getTypeEncoding(class_getInstanceMethod(cls, replacement)))) method_setImplementation(class_getInstanceMethod(cls, original), replacementImplementation);
    }
}

@interface UIFont (IBCustomFonts)
@end

@implementation UIFont (IBCustomFonts)

static NSString *const SSRegular = @"SourceSansPro-Regular";
static NSString *const SSBold = @"SourceSansPro-Bold";
static NSString *const SSLight = @"SourceSansPro-Light";
static NSString *const SSSemibold = @"SourceSansPro-Semibold";

+ (UIFontDescriptor *)mapSystemFontWithDescriptor:(UIFontDescriptor *)descriptor size:(CGFloat)size {
    NSString *fontName = [descriptor.fontAttributes objectForKey:UIFontDescriptorNameAttribute];
    if ([fontName isEqualToString:SSRegular] ||
        [fontName isEqualToString:SSBold] ||
        [fontName isEqualToString:SSLight] ||
        [fontName isEqualToString:SSSemibold]) {
        NSString *thisFontName = [self mapSystemFontWithName:fontName];
        return [UIFontDescriptor fontDescriptorWithName:thisFontName size:size];
    }
    else {
        return descriptor;
    }
}

+ (NSString *)mapSystemFontWithName:(NSString *)fontName {
    if ([fontName isEqualToString:SSRegular]) {
        return [[MidtransUIThemeManager shared].themeFont fontNameRegular];
    }
    else if ([fontName isEqualToString:SSBold]) {
        return [[MidtransUIThemeManager shared].themeFont fontNameBold];
    }
    else if ([fontName isEqualToString:SSLight]) {
        return [[MidtransUIThemeManager shared].themeFont fontNameLight];
    }
    else if ([fontName isEqualToString:SSSemibold]) {
        return [[MidtransUIThemeManager shared].themeFont fontNameRegular];
    }
    else {
        return fontName;
    }
}

+ (void)initialize {
    if (self == [UIFont class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray *methods = @[@"fontWithName:size:", @"fontWithName:size:traits:", @"fontWithDescriptor:size:"];
            for (NSString* methodName in methods) {
                standard_swizzle(self, NSSelectorFromString(methodName), NSSelectorFromString([NSString stringWithFormat:@"new_%@", methodName]));
            }
        });
    }
}

+(UIFont*)new_fontWithName:(NSString*)fontName size:(CGFloat)fontSize {
    return [self new_fontWithName:[self mapSystemFontWithName:fontName] size:fontSize];
}

+(UIFont*)new_fontWithName:(NSString*)fontName size:(CGFloat)fontSize traits:(int)traits {
    return [self new_fontWithName:[self mapSystemFontWithName:fontName] size:fontSize traits:traits];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

+(UIFont*)new_fontWithDescriptor:(UIFontDescriptor*)descriptor size:(CGFloat)fontSize {
    return [self new_fontWithDescriptor:[self mapSystemFontWithDescriptor:descriptor size:fontSize] size:fontSize];
}
#endif
@end
