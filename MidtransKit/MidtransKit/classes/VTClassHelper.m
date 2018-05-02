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
    return [NSString stringWithFormat:@"Rp %@", [nf stringFromNumber:self]];
}

@end

@implementation VTClassHelper
+ (NSBundle *)localeBundle {
    static NSBundle *bundle;
    NSString *stringsBundlePath = [VTBundle
                                   pathForResource:@"Localizable"
                                   ofType:@"strings" inDirectory:nil forLocalization:[MidtransDeviceHelper deviceCurrentLanguage]];
    
    bundle = [NSBundle bundleWithPath:stringsBundlePath];
    return bundle;
}


+ (NSBundle*)kitBundle {
    static dispatch_once_t onceToken;
    static NSBundle *midtransKitBundle;
    dispatch_once(&onceToken, ^{
        midtransKitBundle = [NSBundle bundleWithPath:@"MidtransKit.bundle"];
        if (midtransKitBundle == nil) {
            // This might be the same as the previous check if not using a dynamic framework
            NSString *path = [[NSBundle bundleForClass:[VTClassHelper class]] pathForResource:@"MidtransKit" ofType:@"bundle"];
            midtransKitBundle = [NSBundle bundleWithPath:path];
        }
        
        if (midtransKitBundle == nil) {
            // This will be the same as mainBundle if not using a dynamic framework
            midtransKitBundle = [NSBundle bundleForClass:[VTClassHelper class]];
        }
        
        if (midtransKitBundle == nil) {
            midtransKitBundle = [NSBundle mainBundle];
        }
    });
    return midtransKitBundle;
}
+ (NSString *)getTranslationFromAppBundleForString:(NSString *)originalText {
   
    NSString *language = [NSString stringWithFormat:@"%@_lang",[MidtransDeviceHelper deviceCurrentLanguage]];
   
    if (![[MidtransDeviceHelper deviceCurrentLanguage] isEqualToString:@"en"] && ![[MidtransDeviceHelper deviceCurrentLanguage] isEqualToString:@"id"] ) {
        language = @"en_lang";
    }
    NSDictionary *dictionary =  [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:[VTBundle pathForResource:language ofType:@"json"]] options:kNilOptions error:nil];
    return [dictionary objectForKey:originalText];
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

+ (UIViewController *)rootViewController {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController) {
        if (![topRootViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
            topRootViewController = topRootViewController.presentedViewController;
        }
        else {
            break;
        }
    }
    if (!topRootViewController || [topRootViewController isKindOfClass:[UINavigationController class]] || [topRootViewController isKindOfClass:[UITabBarController class]]) {
        
        if (!topRootViewController) {
            topRootViewController = [[[[UIApplication sharedApplication]delegate]window]rootViewController];
        }
        
        if ([topRootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navController = (UINavigationController*)topRootViewController;
            return navController.topViewController;
        }
        else if ([topRootViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabController = (UITabBarController*)topRootViewController;
            
            if ([tabController.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController* navController = (UINavigationController*)tabController.selectedViewController;
                return navController.topViewController;
            }
            else {
                return tabController.selectedViewController;
            }
        }
        else {
            return topRootViewController;
        }
    }
    return topRootViewController;
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

@implementation NSArray (Item)

- (NSString *)formattedPriceAmount {
    double priceAmount = 0;
    for (MidtransItemDetail *item in self) {
        priceAmount += (item.price.doubleValue * item.quantity.integerValue);
    }
    return @(priceAmount).formattedCurrencyNumber;
}

@end

@implementation MidtransMaskedCreditCard (utilities)

- (NSString *)formattedNumber {
    NSInteger currentLength = self.maskedNumber.length-1; // minus 1 is because dash char
    NSInteger dotCount = 16 - currentLength;
    NSMutableString *dotString = [NSMutableString new];
    for (int i=0; i < dotCount; i++) {
        [dotString appendString:@"\u2022"];
    }
    return [[self.maskedNumber stringByReplacingOccurrencesOfString:@"-" withString:dotString] formattedCreditCardNumber];
}

- (UIImage *)darkIcon {
    switch ([MidtransCreditCardHelper typeFromString:self.maskedNumber]) {
        case VTCreditCardTypeVisa:
            return [UIImage imageNamed:@"VisaDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeJCB:
            return [UIImage imageNamed:@"JCBDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeMasterCard:
            return [UIImage imageNamed:@"MasterCardDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        case VTCreditCardTypeAmex:
            return [UIImage imageNamed:@"AmexDark" inBundle:VTBundle compatibleWithTraitCollection:nil];
        default:
            return nil;
    }
}


@end

