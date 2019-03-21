//
//  MIDCreditCardResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCreditCardResult.h"

@implementation MIDCreditCardResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.approvalCode = [dictionary objectOrNilForKey:@"approval_code"];
        self.bank = [dictionary objectOrNilForKey:@"bank"];
        self.cardType = [dictionary objectOrNilForKey:@"card_type"];
        self.cardToken = [dictionary objectOrNilForKey:@"saved_token_id"];
        self.cardTokenExpireDate = [dictionary objectOrNilForKey:@"saved_token_id_expired_at"];
        self.pointBalanceAmount = [dictionary objectOrNilForKey:@"point_balance_amount"];
        self.pointRedeemAmount = [dictionary objectOrNilForKey:@"point_redeem_amount"];
        self.pointRedeemQuantity = [dictionary objectOrNilForKey:@"point_redeem_quantity"];
        self.RBAURL = [dictionary objectOrNilForKey:@"redirect_url"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.approvalCode forKey:@"approval_code"];
    [result setValue:self.bank forKey:@"bank"];
    [result setValue:self.cardType forKey:@"card_type"];
    [result setValue:self.cardToken forKey:@"saved_token_id"];
    [result setValue:self.cardTokenExpireDate forKey:@"saved_token_id_expired_at"];
    [result setValue:self.pointBalanceAmount forKey:@"point_balance_amount"];
    [result setValue:self.pointRedeemAmount forKey:@"point_redeem_amount"];
    [result setValue:self.pointRedeemQuantity forKey:@"point_redeem_quantity"];
    [result setValue:self.RBAURL forKey:@"redirect_url"];
    return result;
}

@end
