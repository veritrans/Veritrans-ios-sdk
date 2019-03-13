//
//  MIDModelHelper.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"
#import "MIDModelEnums.h"

@interface NSDictionary (extract)

- (id)objectOrNilForKey:(id)key;

@end

@interface NSMutableDictionary (extract)

- (void)setIfNotNilValue:(id)value forKey:(NSString *)key;

@end

@interface NSArray (parse)

- (NSArray *)dictionaryValues;
- (NSArray *)mapToArray:(Class)type;

@end

@interface NSString (helper)
+ (NSString *)nameOfBank:(MIDAcquiringBank)bank;
+ (NSString *)nameOfChannel:(MIDAcquiringChannel)channel;
+ (NSString *)nameOfCreditCardTransactionType:(MIDCreditCardTransactionType)type;
+ (NSString *)nameOfExpiryUnit:(MIDExpiryTimeUnit)unit;
+ (NSString *)nameOfCurrency:(MIDCurrency)currency;
+ (NSString *)nameOfAuth:(MIDAuthentication)auth;
+ (NSString *)typeOfPayment:(MIDWebPaymentType)payment;
+ (NSString *)typeOfVirtualAccount:(MIDBankTransferType)type;

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)stringFromBool:(BOOL)boolean;
+ (NSString *)stringOfPaymentMethod:(MIDPaymentMethod)method;
+ (NSString *)stringOfPaymentCategory:(MIDPaymentCategory)category;

- (MIDCreditCardTransactionType)creditCardTransactionType;
- (MIDCurrency)currencyType;
- (MIDPaymentMethod)paymentMethod;
- (MIDPaymentCategory)paymentCategory;
- (MIDAcquiringBank)acquiringBank;

- (NSNumber *)toNumber;

@end
