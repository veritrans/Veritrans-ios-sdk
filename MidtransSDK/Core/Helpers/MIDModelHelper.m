//
//  MIDModelHelper.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDModelHelper.h"

@implementation NSDictionary (extract)

- (id)objectOrNilForKey:(id)key {
    id object = [self objectForKey:key];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end

@implementation NSMutableDictionary (extract)

- (void)setIfNotNilValue:(id)value forKey:(NSString *)key {
    if (!value || [value isEqual:[NSNull null]]) {
        return;
    }
    [self setValue:value forKey:key];
}

@end

@implementation NSArray (parse)

- (NSArray *)dictionaryValues {
    NSMutableArray *result = [NSMutableArray new];
    for (id mappable in self) {
        if ([mappable respondsToSelector:@selector(dictionaryValue)]) {
            [result addObject:[mappable dictionaryValue]];
        }
    }
    return result;
}

- (NSArray *)mapToArray:(Class)type {
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *json in self) {
        [result addObject:[[type alloc] initWithDictionary:json]];
    }
    return result;
}

@end

@implementation NSString (helper)

+ (NSString *)nameOfBank:(MIDAcquiringBank)bank {
    switch (bank) {
        case MIDAcquiringBankBCA:
            return @"bca";
        case MIDAcquiringBankBNI:
            return @"bni";
        case MIDAcquiringBankBRI:
            return @"bri";
        case MIDAcquiringBankCIMB:
            return @"cimb";
        case MIDAcquiringBankMega:
            return @"mega";
        case MIDAcquiringBankDanamon:
            return @"danamon";
        case MIDAcquiringBankMandiri:
            return @"mandiri";
        case MIDAcquiringBankMaybank:
            return @"maybank";
        default:
            return nil;
    }
}

+ (NSString *)nameOfAuth:(MIDAuthentication)auth {
    switch (auth) {
        case MIDAuthenticationRBA:
            return @"rba";
            
        case MIDAuthentication3DS:
            return @"3ds";
            
        default:
            return @"none";
    }
}

+ (NSString *)nameOfChannel:(MIDAcquiringChannel)channel {
    switch (channel) {
        case MIDAcquiringChannelMIGS:
            return @"migs";
        default:
            return nil;
    }
}

+ (NSString *)nameOfCurrency:(MIDCurrency)currency {
    switch (currency) {
        case MIDCurrencyIDR:
            return @"IDR";
        case MIDCurrencySGD:
            return @"SGD";
    }
}

+ (NSString *)nameOfCreditCardTransactionType:(MIDCreditCardTransactionType)type {
    switch (type) {
        case MIDCreditCardTransactionTypeAuthorize:
            return @"authorize";
        case MIDCreditCardTransactionTypeAuthorizeCapture:
            return @"authorize_capture";
    }
}

+ (NSString *)typeOfPayment:(MIDWebPaymentType)payment {
    switch (payment) {
        case MIDWebPaymentTypeKiosOn:
            return @"kioson";
        case MIDWebPaymentTypeAkulaku:
            return @"akulaku";
        case MIDWebPaymentTypeBRIEpay:
            return @"bri_epay";
        case MIDWebPaymentTypeCIMBClicks:
            return @"cimb_clicks";
        case MIDWebPaymentTypeBCAKlikPay:
            return @"bca_klikpay";
        case MIDWebPaymentTypeMandiriEcash:
            return @"mandiri_ecash";
        case MIDWebPaymentTypeDanamonOnline:
            return @"danamon_online";
    }
}

+ (NSString *)typeOfVirtualAccount:(MIDBankTransferType)type {
    switch (type) {
        case MIDBankTransferTypeBCA:
            return @"bca_va";
        case MIDBankTransferTypeBNI:
            return @"bni_va";
        case MIDBankTransferTypeOther:
            return @"other_va";
        case MIDBankTransferTypePermata:
            return @"permata_va";
        case MIDBankTransferTypeEchannel:
            return @"echannel";
    }
}

+ (NSString *)nameOfExpiryUnit:(MIDExpiryTimeUnit)unit {
    switch (unit) {
        case MIDExpiryTimeUnitDay:
            return @"DAY";
        case MIDExpiryTimeUnitDays:
            return @"DAYS";
        case MIDExpiryTimeUnitHour:
            return @"HOUR";
        case MIDExpiryTimeUnitHours:
            return @"HOURS";
        case MIDExpiryTimeUnitMinute:
            return @"MINUTE";
        case MIDExpiryTimeUnitMinutes:
            return @"MINUTES";
    }
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    [df setDateFormat: format];
    return [df stringFromDate: date];
}

+ (NSString *)stringFromBool:(BOOL)boolean {
    return boolean ? @"true" : @"false";
}

+ (NSString *)stringOfPaymentCategory:(MIDPaymentCategory)category {
    switch (category) {
        case MIDPaymentCategoryStore:
            return @"cstore";
        case MIDPaymentCategoryBankTransfer:
            return @"bank_transfer";
        default:
            return nil;
    }
}

+ (NSString *)stringOfPaymentMethod:(MIDPaymentMethod)method {
    switch (method) {
        case MIDPaymentMethodCreditCard:
            return @"credit_card";
        case MIDPaymentMethodBCAVA:
            return @"bca_va";
        case MIDPaymentMethodMandiriVA:
            return @"echannel";
        case MIDPaymentMethodBNIVA:
            return @"bni_va";
        case MIDPaymentMethodPermataVA:
            return @"permata_va";
        case MIDPaymentMethodOtherVA:
            return @"other_va";
        case MIDPaymentMethodGopay:
            return @"gopay";
        case MIDPaymentMethodKlikbca:
            return @"bca_klikbca";
        case MIDPaymentMethodBCAKlikpay:
            return @"bca_klikpay";
        case MIDPaymentMethodMandiriClickpay:
            return @"mandiri_clickpay";
        case MIDPaymentMethodCIMBClicks:
            return @"cimb_clicks";
        case MIDPaymentMethodDanamonOnline:
            return @"danamon_online";
        case MIDPaymentMethodBRIEpay:
            return @"bri_epay";
        case MIDPaymentMethodMandiriECash:
            return @"mandiri_ecash";
        case MIDPaymentMethodIndomaret:
            return @"indomaret";
        case MIDPaymentMethodAkulaku:
            return @"akulaku";
        case MIDPaymentMethodTelkomselCash:
            return @"telkomsel_cash";
        case MIDPaymentMethodAlfamart:
            return @"alfamart";
        default:
            return nil;
    }
}

- (MIDPaymentCategory)paymentCategory {
    if ([self isEqualToString:@"bank_transfer"]) {
        return MIDPaymentCategoryBankTransfer;
    } else if ([self isEqualToString:@"cstore"]) {
        return MIDPaymentCategoryStore;
    } else {
        return MIDPaymentCategoryGeneral;
    }
}

- (MIDPaymentMethod)paymentMethod {
    if ([self isEqualToString:@"credit_card"]) {
        return MIDPaymentMethodCreditCard;
    } else if ([self isEqualToString:@"bca_va"]) {
        return MIDPaymentMethodBCAVA;
    } else if ([self isEqualToString:@"echannel"]) {
        return MIDPaymentMethodMandiriVA;
    } else if ([self isEqualToString:@"bni_va"]) {
        return MIDPaymentMethodBNIVA;
    } else if ([self isEqualToString:@"permata_va"]) {
        return MIDPaymentMethodPermataVA;
    } else if ([self isEqualToString:@"other_va"]) {
        return MIDPaymentMethodOtherVA;
    } else if ([self isEqualToString:@"gopay"]) {
        return MIDPaymentMethodGopay;
    } else if ([self isEqualToString:@"bca_klikbca"]) {
        return MIDPaymentMethodKlikbca;
    } else if ([self isEqualToString:@"bca_klikpay"]) {
        return MIDPaymentMethodBCAKlikpay;
    } else if ([self isEqualToString:@"mandiri_clickpay"]) {
        return MIDPaymentMethodMandiriClickpay;
    } else if ([self isEqualToString:@"cimb_clicks"]) {
        return MIDPaymentMethodCIMBClicks;
    } else if ([self isEqualToString:@"danamon_online"]) {
        return MIDPaymentMethodDanamonOnline;
    } else if ([self isEqualToString:@"bri_epay"]) {
        return MIDPaymentMethodBRIEpay;
    } else if ([self isEqualToString:@"mandiri_ecash"]) {
        return MIDPaymentMethodMandiriECash;
    } else if ([self isEqualToString:@"indomaret"]) {
        return MIDPaymentMethodIndomaret;
    } else if ([self isEqualToString:@"akulaku"]) {
        return MIDPaymentMethodAkulaku;
    } else if ([self isEqualToString:@"telkomsel_cash"]) {
        return MIDPaymentMethodTelkomselCash;
    } else if ([self isEqualToString:@"alfamart"]) {
        return MIDPaymentMethodAlfamart;
    } else {
        return MIDPaymentMethodUnknown;
    }
}

- (MIDCreditCardTransactionType)creditCardTransactionType {
    if ([self isEqualToString:@"authorize"]) {
        return MIDCreditCardTransactionTypeAuthorize;
    } else {
        return MIDCreditCardTransactionTypeAuthorizeCapture;
    }
}

- (MIDCurrency)currencyType {
    if ([self isEqualToString:@"SGD"]) {
        return MIDCurrencySGD;
    } else {
        return MIDCurrencyIDR;
    }
}

- (MIDAcquiringBank)acquiringBank {
    if ([self isEqualToString:@"bca"]) {
        return MIDAcquiringBankBCA;
    }
    else if ([self isEqualToString:@"bni"]) {
        return MIDAcquiringBankBNI;
    }
    else if ([self isEqualToString:@"bri"]) {
        return MIDAcquiringBankBRI;
    }
    else if ([self isEqualToString:@"cimb"]) {
        return MIDAcquiringBankCIMB;
    }
    else if ([self isEqualToString:@"mega"]) {
        return MIDAcquiringBankMega;
    }
    else if ([self isEqualToString:@"danamon"]) {
        return MIDAcquiringBankDanamon;
    }
    else if ([self isEqualToString:@"mandiri"]) {
        return MIDAcquiringBankMandiri;
    }
    else if ([self isEqualToString:@"maybank"]) {
        return MIDAcquiringBankMaybank;
    } else {
        return MIDAcquiringBankNone;
    }
}

- (NSNumber *)toNumber {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return [f numberFromString:self];
}

@end
