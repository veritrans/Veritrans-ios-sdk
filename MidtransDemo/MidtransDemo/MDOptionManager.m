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
        self.ccPaymentType = [self ccPaymentOptionFromObject:defaults_object(@"md_cc_type")];
        self.secure3D = [self booleanOptionFromObject: defaults_object(@"md_3ds")];
        self.issuingBank = [self issuingBankOptionFromObject:defaults_object(@"md_bank")];
        self.saveCard = [self booleanOptionFromObject: defaults_object(@"md_savecard")];
        self.promo = [self booleanOptionFromObject: defaults_object(@"md_savecard")];
        self.preauth = [self booleanOptionFromObject:defaults_object(@"md_preauth")];
        self.customExpiry = [self expireTimeOptionFromData:defaults_object(@"md_expire")];
        self.colorTheme = [self colorOptionFromData:defaults_object(@"md_color")];
    }
    return self;
}

- (void)setCcPaymentType:(NSString *)ccPaymentType {
    if ([ccPaymentType isEqualToString:@"Two Clicks"]) {
        CC_CONFIG.paymentType = MTCreditCardPaymentTypeTwoclick;
    }
    else if ([ccPaymentType isEqualToString:@"One Click"]) {
        CC_CONFIG.paymentType = MTCreditCardPaymentTypeOneclick;
    }
    else {
        CC_CONFIG.paymentType = MTCreditCardPaymentTypeNormal;
    }
    defaults_set_object(@"md_cc_type", @(CC_CONFIG.paymentType));
}
- (NSString *)ccPaymentType {
    return [self ccPaymentOptionFromObject:@(CC_CONFIG.paymentType)];
}

- (void)setSecure3D:(NSString *)secure3D {
    if ([secure3D isEqualToString:@"Enable"]) {
        CC_CONFIG.secure3DEnabled = YES;
    }
    else {
        CC_CONFIG.secure3DEnabled = NO;
    }
    defaults_set_object(@"md_3ds", @(CC_CONFIG.secure3DEnabled));
}
- (NSString *)secure3D {
    return [self booleanOptionFromObject:@(CC_CONFIG.secure3DEnabled)];
}

- (void)setIssuingBank:(NSString *)issuingBank {
    if ([issuingBank isEqualToString:@"BNI"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankBNI;
    }
    else if ([issuingBank isEqualToString:@"BCA"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankBCA;
    }
    else if ([issuingBank isEqualToString:@"Maybank"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankMaybank;
    }
    else if ([issuingBank isEqualToString:@"BRI"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankBRI;
    }
    else if ([issuingBank isEqualToString:@"CIMB"]) {
        CC_CONFIG.acquiringBank = MTAcquiringBankCIMB;
    }
    else {
        CC_CONFIG.acquiringBank = MTAcquiringBankMandiri;
    }
    defaults_set_object(@"md_bank", @(CC_CONFIG.acquiringBank));
}
- (NSString *)issuingBank {
    return [self issuingBankOptionFromObject:@(CC_CONFIG.acquiringBank)];
}

- (void)setSaveCard:(NSString *)saveCard {
    if ([saveCard isEqualToString:@"Enable"]) {
        CC_CONFIG.saveCardEnabled = YES;
    }
    else {
        CC_CONFIG.saveCardEnabled = NO;
    }
    defaults_set_object(@"md_savecard", @(CC_CONFIG.saveCardEnabled));
}
- (NSString *)saveCard {
    return [self booleanOptionFromObject:@(CC_CONFIG.saveCardEnabled)];
}

- (void)setPromo:(NSString *)promo {
    if ([promo isEqualToString:@"Enable"]) {
        CC_CONFIG.promoEnabled = YES;
    }
    else {
        CC_CONFIG.promoEnabled = NO;
    }
    defaults_set_object(@"md_promo", @(CC_CONFIG.promoEnabled));
}
- (NSString *)promo {
    return [self booleanOptionFromObject:@(CC_CONFIG.promoEnabled)];
}

- (void)setPreauth:(NSString *)preauth {
    if ([preauth isEqualToString:@"Enable"]) {
        CC_CONFIG.preauthEnabled = YES;
    }
    else {
        CC_CONFIG.preauthEnabled = NO;
    }
    defaults_set_object(@"md_preauth", @(CC_CONFIG.preauthEnabled));
}
- (NSString *)preauth {
    return [self booleanOptionFromObject:@(CC_CONFIG.preauthEnabled)];
}

- (void)setColorTheme:(NSString *)colorTheme {
    UIColor *color;
    if ([colorTheme isEqualToString:@"Red"]) {
        color = [UIColor colorWithHexString:@"#d4385c"];
    }
    else if ([colorTheme isEqualToString:@"Green"]) {
        color = [UIColor colorWithHexString:@"#3bb740"];
    }
    else if ([colorTheme isEqualToString:@"Orange"]) {
        color = [UIColor colorWithHexString:@"#ff8c00"];
    }
    else if ([colorTheme isEqualToString:@"Black"]) {
        color = [UIColor colorWithHexString:@"#151515"];
    }
    else {
        color = [UIColor colorWithHexString:@"#2f80c2"];
    }
    defaults_set_object(@"md_color", [NSKeyedArchiver archivedDataWithRootObject:color]);
}
- (NSString *)colorTheme {
    return [self colorOptionFromData:defaults_object(@"md_color")];
}

- (void)setCustomExpiry:(NSString *)customExpiry {
    MidtransTransactionExpire *expireTime;
    if ([customExpiry isEqualToString:@"1 Minute"]) {
        expireTime =
        [[MidtransTransactionExpire alloc] initWithExpireTime:[NSDate date]
                                               expireDuration:1
                                                 withUnitTime:MindtransTimeUnitTypeMinute];
    }
    else if ([customExpiry isEqualToString:@"1 Hour"]) {
        expireTime =
        [[MidtransTransactionExpire alloc] initWithExpireTime:[NSDate date]
                                               expireDuration:1
                                                 withUnitTime:MindtransTimeUnitTypeHour];
    }
    
    if (expireTime) {
        defaults_set_object(@"md_expire",[NSKeyedArchiver archivedDataWithRootObject:expireTime]);
    }
    else {
        defaults_remove(@"md_expire");
    }
}
- (NSString *)customExpiry {
    return [self expireTimeOptionFromData:defaults_object(@"md_expire")];
}

#pragma mark - Helper

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
        if ([color isEqual:[UIColor colorWithHexString:@"#d4385c"]]) {
            return @"Red";
        }
        else if ([color isEqual:[UIColor colorWithHexString:@"#3bb740"]]) {
            return @"Green";
        }
        else if ([color isEqual:[UIColor colorWithHexString:@"#ff8c00"]]) {
            return @"Orange";
        }
        else if ([color isEqual:[UIColor colorWithHexString:@"#151515"]]) {
            return @"Black";
        }
    }
    return @"Blue";
}

- (NSString *)booleanOptionFromObject:(id)object {
    return [object boolValue]? @"Enable" : @"Disable";
}

@end
