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

+ (NSString *)mapSystemFontWithName:(NSString *)fontName size:(CGFloat)fontSize{
    if ([fontName isEqualToString:@"SourceSansPro-Regular"]) {
        return [[MidtransUIThemeManager shared].themeFont fontNameRegular];
    } else if ([fontName isEqualToString:@"SourceSansPro-Bold"]) {
        return [[MidtransUIThemeManager shared].themeFont fontNameBold];
    } else if ([fontName isEqualToString:@"SourceSansPro-Light"]) {
        return [[MidtransUIThemeManager shared].themeFont fontNameLight];
    } else if ([fontName isEqualToString:@"SourceSansPro-Semibold"]) {
        return [[MidtransUIThemeManager shared].themeFont fontNameRegular];
    } else {
        //it should be nil
        //it can cause terrible bug if not nil
        return nil;
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
    return [self new_fontWithName:[self mapSystemFontWithName:fontName size:fontSize] size:fontSize];
}
+(UIFont*)new_fontWithName:(NSString*)fontName size:(CGFloat)fontSize traits:(int)traits {
    return [self new_fontWithName:[self mapSystemFontWithName:fontName size:fontSize] size:fontSize traits:traits];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

+(UIFont*)new_fontWithDescriptor:(UIFontDescriptor*)descriptor size:(CGFloat)fontSize {
    NSString *fontName = [descriptor.fontAttributes objectForKey:UIFontDescriptorNameAttribute];
    NSString* newName = [self mapSystemFontWithName:fontName size:fontSize];
    return [self new_fontWithDescriptor: newName ? [UIFontDescriptor fontDescriptorWithName:newName size:fontSize] : descriptor size:fontSize];
}
#endif
@end
