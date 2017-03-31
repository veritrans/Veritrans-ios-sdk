//
//  MDOptionManager.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/27/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionManager.h"
#import "MDUtils.h"
#import <MidtransKit/MidtransKit.h>

@implementation MDOptionManager

+ (MDOptionManager *)shared {
    static MDOptionManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        self.secure3DOption = [self booleanOptionFromObject: defaults_object(@"md_3ds")];
        self.issuingBankOption = [self issuingBankOptionFromObject:defaults_object(@"md_bank")];
        self.saveCardOption = [self booleanOptionFromObject: defaults_object(@"md_savecard")];
        self.promoOption = [self booleanOptionFromObject: defaults_object(@"md_savecard")];
        self.preauthOption = [self booleanOptionFromObject:defaults_object(@"md_preauth")];
        self.expireTimeOption = [self expireTimeOptionFromData:defaults_object(@"md_expire")];
        self.colorOption = [self colorOptionFromData:defaults_object(@"md_color")];
        self.ccTypeOption = [self ccPaymentOptionFromObject:defaults_object(@"md_cc_type")];
    }
    return self;
}

- (void)setCcTypeOption:(NSString *)ccTypeOption {
    _ccTypeOption = ccTypeOption;
    defaults_set_object(@"md_cc_type", [self ccTypeValue]);
}
- (void)setSecure3DOption:(NSString *)secure3DOption {
    _secure3DOption = secure3DOption;
    defaults_set_object(@"md_3ds", [self secure3DValue]);
}
- (void)setIssuingBankOption:(NSString *)issuingBankOption {
    _issuingBankOption = issuingBankOption;
    defaults_set_object(@"md_bank", [self issuingBankValue]);
}
- (void)setSaveCardOption:(NSString *)saveCardOption {
    _saveCardOption = saveCardOption;
    defaults_set_object(@"md_savecard", [self saveCardValue]);
}
- (void)setPromoOption:(NSString *)promoOption {
    _promoOption = promoOption;
    defaults_set_object(@"md_promo", [self promoValue]);
}
- (void)setPreauthOption:(NSString *)preauthOption {
    _preauthOption = preauthOption;
    defaults_set_object(@"md_preauth", [self preauthValue]);
}
- (void)setColorOption:(NSString *)colorOption {
    _colorOption = colorOption;
    defaults_set_object(@"md_color", [self colorValue]);
}
- (void)setExpireTimeOption:(NSString *)expireTimeOption {
    _expireTimeOption = expireTimeOption;
    if ([self expireTimeValue]) {
        defaults_set_object(@"md_expire", [self expireTimeValue]);
    }
    else {
        defaults_remove(@"md_expire");
    }
}

#pragma mark - Values

- (id)expireTimeValue {
    MidtransTransactionExpire *expireTime;
    if ([_expireTimeOption isEqualToString:@"1 Minute"]) {
        expireTime =
        [[MidtransTransactionExpire alloc] initWithExpireTime:[NSDate date]
                                               expireDuration:1
                                                 withUnitTime:MindtransTimeUnitTypeMinute];
    }
    else if ([_expireTimeOption isEqualToString:@"1 Hour"]) {
        expireTime =
        [[MidtransTransactionExpire alloc] initWithExpireTime:[NSDate date]
                                               expireDuration:1
                                                 withUnitTime:MindtransTimeUnitTypeHour];
    }
    if (expireTime) {
        return [NSKeyedArchiver archivedDataWithRootObject:expireTime];
    }
    else {
        return nil;
    }
}
- (id)colorValue {
    return [NSKeyedArchiver archivedDataWithRootObject:[MDOptionManager colorWithOption:_colorOption]];
}
- (id)preauthValue {
    if ([_preauthOption isEqualToString:@"Enable"]) {
        CC_CONFIG.preauthEnabled = YES;
    }
    else {
        CC_CONFIG.preauthEnabled = NO;
    }
    return @(CC_CONFIG.preauthEnabled);
}
- (id)promoValue {
    if ([_promoOption isEqualToString:@"Enable"]) {
        CC_CONFIG.promoEnabled = YES;
    }
    else {
        CC_CONFIG.promoEnabled = NO;
    }
    return @(CC_CONFIG.promoEnabled);
}
- (id)ccTypeValue {
    if ([_ccTypeOption isEqualToString:@"Two Clicks"]) {
        CC_CONFIG.paymentType = MTCreditCardPaymentTypeTwoclick;
    }
    else if ([_ccTypeOption isEqualToString:@"One Click"]) {
        CC_CONFIG.paymentType = MTCreditCardPaymentTypeOneclick;
    }
    else {
        CC_CONFIG.paymentType = MTCreditCardPaymentTypeNormal;
    }
    return @(CC_CONFIG.paymentType);
}
- (id)secure3DValue {
    if ([_secure3DOption isEqualToString:@"Enable"]) {
        CC_CONFIG.secure3DEnabled = YES;
    }
    else {
        CC_CONFIG.secure3DEnabled = NO;
    }
    return @(CC_CONFIG.secure3DEnabled);
}
- (id)issuingBankValue {
    if ([_issuingBankOption isEqualToString:@"BNI"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankBNI;
    }
    else if ([_issuingBankOption isEqualToString:@"BCA"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankBCA;
    }
    else if ([_issuingBankOption isEqualToString:@"Maybank"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankMaybank;
    }
    else if ([_issuingBankOption isEqualToString:@"BRI"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankBRI;
    }
    else if ([_issuingBankOption isEqualToString:@"CIMB"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankCIMB;
    }
    else {
        CC_CONFIG.acquiringBank = MTAcquiringBankMandiri;
    }
    return @(CC_CONFIG.acquiringBank);
}
- (id)saveCardValue {
    if ([_saveCardOption isEqualToString:@"Enable"]) {
        CC_CONFIG.saveCardEnabled = YES;
    }
    else {
        CC_CONFIG.saveCardEnabled = NO;
    }
    return @(CC_CONFIG.saveCardEnabled);
}

#pragma mark - Helper

+ (UIColor *)colorWithOption:(NSString *)colorOption {
    UIColor *color;
    if ([colorOption isEqualToString:@"Red"]) {
        color = RGB(212, 56, 92);
    }
    else if ([colorOption isEqualToString:@"Green"]) {
        color = RGB(59, 183, 64);
    }
    else if ([colorOption isEqualToString:@"Orange"]) {
        color = RGB(255, 140, 0);
    }
    else if ([colorOption isEqualToString:@"Black"]) {
        color = RGB(21, 21, 21);
    }
    else {
        color = RGB(47, 128, 194);
    }
    return color;
}
- (NSString *)ccPaymentOptionFromObject:(id)type {
    MTCreditCardPaymentType _type = [type integerValue];
    switch (_type) {
        case MTCreditCardPaymentTypeNormal:
            return @"Normal";
        case MTCreditCardPaymentTypeOneclick:
            return @"One Click";
        case MTCreditCardPaymentTypeTwoclick:
            return @"Two Clicks";
    }
}
- (NSString *)issuingBankOptionFromObject:(id)acquiringBank {
    switch ([acquiringBank integerValue]) {
        case MTAcquiringBankCIMB:
            return @"CIMB";
        case MTAcquiringBankBRI:
            return @"BRI";
        case MTAcquiringBankMaybank:
            return @"Maybank";
        case MTAcquiringBankBCA:
            return @"BCA";
        case MTAcquiringBankBNI:
            return @"BNI";
        default:
            return @"Mandiri";
    }
}
- (NSString *)expireTimeOptionFromData:(NSData *)expireTimeData {
    if (expireTimeData) {
        MidtransTransactionExpire *expireTime = [NSKeyedUnarchiver unarchiveObjectWithData:expireTimeData];
        if ([expireTime.unit isEqualToString:@"HOUR"]) {
            return @"1 Hour";
        }
        else {
            return @"1 Minute";
        }
    }
    else {
        return @"No Expiry";
    }
}
- (NSString *)colorOptionFromData:(NSData *)colorData {
    if (colorData) {
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        if ([color isEqualToColor:RGB(212, 56, 92)]) {
            return @"Red";
        }
        else if ([color isEqualToColor:RGB(59, 183, 64)]) {
            return @"Green";
        }
        else if ([color isEqualToColor:RGB(255, 140, 0)]) {
            return @"Orange";
        }
        else if ([color isEqualToColor:RGB(21, 21, 21)]) {
            return @"Black";
        }
    }
    return @"Blue";
}
- (NSString *)booleanOptionFromObject:(id)object {
    return [object boolValue]? @"Enable" : @"Disable";
}

@end
