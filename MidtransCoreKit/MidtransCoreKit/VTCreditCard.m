//
//  VTCreditCard.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCreditCard.h"
#import "VTConfig.h"

#define VTVisaRegex         @"^4[0-9]{3}?"
#define VTMasterCardRegex   @"^5[1-5][0-9]{2}$"
#define VTJCBRegex          @"^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"

@interface VTCreditCard ()
@property (nonatomic, readwrite) NSString *number;
@property (nonatomic, readwrite) NSString *bank;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@property (nonatomic, readwrite) NSNumber *expiryMonth;
@property (nonatomic, readwrite) NSNumber *expiryYear;
@property (nonatomic, readwrite) BOOL saved;
@property (nonatomic, readwrite) BOOL secure;
@property (nonatomic, readwrite) NSString *type;
@end

@implementation VTCreditCard

+ (instancetype)dataWithNumber:(NSString *)number expiryMonth:(NSNumber *)expiryMonth expiryYear:(NSNumber *)expiryYear saved:(BOOL)saved {
    VTCreditCard *card = [[VTCreditCard alloc] init];
    card.number = number;
    card.expiryMonth = expiryMonth;
    card.expiryYear = expiryYear;
    card.saved = saved;
    card.type = [VTCreditCard checkTypeStringWithNumber:number];
    return card;
}

+ (NSString *)checkTypeStringWithNumber:(NSString *)number {
    switch ([self typeWithNumber:number]) {
        case VTCreditCardTypeVisa:
            return @"VISA";
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

+ (VTCreditCardType)typeWithNumber:(NSString *)cardNumber
{
    if([cardNumber length] < 4) return VTCreditCardTypeUnknown;
    
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
            case VTCreditCardTypeJCB :
                regex = [NSRegularExpression regularExpressionWithPattern:VTJCBRegex options:0 error:&error];
                break;
        }
        
        NSUInteger matches = [regex numberOfMatchesInString:cardNumber options:0 range:NSMakeRange(0, 4)];
        if(matches == 1) return cardType;
        
    }
    
    return VTCreditCardTypeUnknown;
}

@end
