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
@property (nonatomic, readwrite) NSString *expiryYear;
@property (nonatomic, readwrite) NSString *expiryMonth;
@property (nonatomic, readwrite) NSString *number;
@property (nonatomic, readwrite) NSString *holder;
@property (nonatomic, readwrite) NSString *cvv;
@end

@implementation VTCreditCard

+ (instancetype)cardWithNumber:(NSString *)number
                   expiryMonth:(NSString *)expiryMonth
                    expiryYear:(NSString *)expiryYear
                           cvv:(NSString *)cvv
                        holder:(NSString *)holder {
    VTCreditCard *card = [[VTCreditCard alloc] init];
    card.number = number;
    card.expiryMonth = expiryMonth;
    card.expiryYear = expiryYear;
    card.holder = holder;
    card.cvv = cvv;
    return card;
}

+ (NSString *)typeStringWithNumber:(NSString *)number {
    VTCreditCardType type = [self typeWithNumber:number];
    switch (type) {
        case VTCreditCardTypeVisa:
            return @"Visa";
            break;
        case VTCreditCardTypeMasterCard:
            return @"MasterCard";
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
