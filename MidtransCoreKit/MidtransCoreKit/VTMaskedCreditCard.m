//
//  VTMaskedCreditCard.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMaskedCreditCard.h"

@interface VTMaskedCreditCard()
@property (nonatomic, readwrite) NSString *maskedNumber;
@property (nonatomic, readwrite) NSString *savedTokenId;
@end

@implementation VTMaskedCreditCard

+ (instancetype)maskedCardFromData:(NSDictionary *)data; {
    VTMaskedCreditCard *card = [VTMaskedCreditCard new];
    card.maskedNumber = [data[@"masked_card"] stringByReplacingOccurrencesOfString:@"-" withString:@"XXXXXX"];
    card.savedTokenId = data[@"saved_token_id"];
    return card;
}

@end
