//
//  MIDCreditCardInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCreditCardInfo.h"
#import "MIDModelHelper.h"

@implementation MIDCreditCardInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.blacklistBins forKey:@"blacklist_bins"];
    [result setValue:self.whitelistBins forKey:@"whitelist_bins"];
    [result setValue:[self.savedCards dictionaryValues] forKey:@"saved_tokens"];
    [result setValue:@(self.saveCard) forKey:@"save_card"];
    [result setValue:@(self.secure) forKey:@"secure"];
    [result setValue:@(self.merchantSaveCard) forKey:@"merchant_save_card"];
    [result setValue:[self.installment dictionaryValue] forKey:@"installment"];
    [result setValue:[NSString nameOfCreditCardTransactionType:self.type] forKey:@"type"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.blacklistBins = [dictionary objectOrNilForKey:@"blacklist_bins"];
        self.whitelistBins = [dictionary objectOrNilForKey:@"whitelist_bins"];
        self.savedCards = [[dictionary objectOrNilForKey:@"saved_tokens"] mapToArray:[MIDSavedCardInfo class]];
        self.saveCard = [dictionary objectOrNilForKey:@"save_card"];
        self.secure = [dictionary objectOrNilForKey:@"secure"];
        self.merchantSaveCard = [dictionary objectOrNilForKey:@"merchant_save_card"];
        self.installment = [[MIDInstallmentInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"installment"]];
        self.type = [[dictionary objectOrNilForKey:@"type"] creditCardTransactionType];
    }
    return self;
}

@end
