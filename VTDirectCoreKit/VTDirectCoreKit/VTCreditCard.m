//
//  VTCreditCard.m
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCreditCard.h"

#define VTVisaRegex         @"^4[0-9]{3}?"
#define VTMasterCardRegex   @"^5[1-5][0-9]{2}$"
#define VTAmexRegex         @"^3[47][0-9]{2}$"
#define VTDinersClubRegex	@"^3(?:0[0-5]|[68][0-9])[0-9]$"
#define VTDiscoverRegex		@"^6(?:011|5[0-9]{2})$"
#define VTJCBRegex          @"^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"

@interface VTCreditCard ()
@property (nonatomic, readwrite) NSNumber *number;
@property (nonatomic, readwrite) NSNumber *cvv;
@property (nonatomic, readwrite) NSString *bank;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@property (nonatomic, readwrite) NSNumber *expiryMonth;
@property (nonatomic, readwrite) NSNumber *expiryYear;
@property (nonatomic, readwrite) BOOL secure;
@property (nonatomic, readwrite) NSString *type;
@end

@implementation VTCreditCard

+ (instancetype)cardWithNumber:(NSNumber *)number
                   expiryMonth:(NSNumber *)expiryMonth
                    expiryYear:(NSNumber *)expiryYear
                           cvv:(NSNumber *)cvv {
    VTCreditCard *card = [[VTCreditCard alloc] init];
    card.number = number;
    card.expiryMonth = expiryMonth;
    card.expiryYear = expiryYear;
    card.cvv = cvv;
    card.type = [VTCreditCard checkTypeStringWithNumber:number];
    return card;
}

+ (NSString *)checkTypeStringWithNumber:(NSNumber *)number {
    switch ([self checkTypeWithNumber:number]) {
        case VTCreditCardTypeVisa:
            return @"VISA";
            break;
        case VTCreditCardTypeAmex:
            return @"AMEX";
            break;
        case VTCreditCardTypeDinersClub:
            return @"DINERSCLUB";
            break;
        case VTCreditCardTypeDiscover:
            return @"DISCOVER";
            break;
        case VTCreditCardTypeMasterCard:
            return @"MASTERCARD";
            break;
        case VTCreditCardTypeJCB:
            return @"JCB";
            break;
        case VTCreditCardTypeUnknown:
            return nil;
            break;
    }
}

+ (VTCreditCardType)checkTypeWithNumber:(NSNumber *)cardNumber
{
    NSString *numberString = cardNumber.stringValue;
    
    if([numberString length] < 4) return VTCreditCardTypeUnknown;
    
    VTCreditCardType cardType;
    NSRegularExpression *regex;
    NSError *error;
    
    for(NSUInteger i = 0; i < VTCreditCardTypeUnknown; ++i) {
        
        cardType = i;
        
        switch(i) {
            case VTCreditCardTypeVisa:
                regex = [NSRegularExpression regularExpressionWithPattern:VTVisaRegex options:0 error:&error];
                break;
            case VTCreditCardTypeMasterCard:
                regex = [NSRegularExpression regularExpressionWithPattern:VTMasterCardRegex options:0 error:&error];
                break;
            case VTCreditCardTypeAmex:
                regex = [NSRegularExpression regularExpressionWithPattern:VTAmexRegex options:0 error:&error];
                break;
            case VTCreditCardTypeDinersClub:
                regex = [NSRegularExpression regularExpressionWithPattern:VTDinersClubRegex options:0 error:&error];
                break;
            case VTCreditCardTypeDiscover:
                regex = [NSRegularExpression regularExpressionWithPattern:VTDiscoverRegex options:0 error:&error];
                break;
            case VTCreditCardTypeJCB :
                regex = [NSRegularExpression regularExpressionWithPattern:VTJCBRegex options:0 error:&error];
                break;
        }
        
        NSUInteger matches = [regex numberOfMatchesInString:numberString options:0 range:NSMakeRange(0, 4)];
        if(matches == 1) return cardType;
        
    }
    
    return VTCreditCardTypeUnknown;
}

@end
