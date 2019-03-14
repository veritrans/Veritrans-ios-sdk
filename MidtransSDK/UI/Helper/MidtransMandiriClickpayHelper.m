//
//  VTMandiriClickpayHelper.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransMandiriClickpayHelper.h"
#import "MidtransHelper.h"

@implementation MidtransMandiriClickpayHelper

+ (NSString *_Nonnull)generateInput1FromCardNumber:(NSString *_Nonnull)cardNumber {
    if ([cardNumber length] == 0) {
        return @"-";
    }
    
    cardNumber = [cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger startIndex = [cardNumber length] - 10;
    if (startIndex > 0) {
        return [cardNumber substringFromIndex:startIndex];
    } else {
        return cardNumber;
    }
}

+ (NSString *_Nonnull)generateInput2FromGrossAmount:(NSNumber *_Nonnull)grossAmount {
    return [grossAmount roundingWithoutCurrency];
}

+ (NSString *_Nonnull)generateInput3 {
    NSString *letters = @"0123456789";
    NSInteger len = 5;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end
