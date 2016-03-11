//
//  VTRegisteredCreditCard.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTRegisteredCreditCard.h"

@interface VTRegisteredCreditCard()
@property (nonatomic, readwrite) NSString *maskedNumber;
@property (nonatomic, readwrite) NSString *savedTokenId;
@end

@implementation VTRegisteredCreditCard

+ (instancetype)registeredCardFromData:(NSDictionary *)data {
    VTRegisteredCreditCard *card = [VTRegisteredCreditCard new];
    card.maskedNumber = data[@"masked_card"];
    card.savedTokenId = data[@"saved_token_id"];
    return card;
}

@end
