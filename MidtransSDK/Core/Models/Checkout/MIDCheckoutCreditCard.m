//
//  MIDCreditCardOption.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutCreditCard.h"
#import "MIDModelHelper.h"

@implementation MIDCheckoutCreditCard

- (nonnull NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:@(self.saveCard) forKey:@"save_card"];
    [result setValue:@(self.secure) forKey:@"secure"];
    [result setValue:[NSString nameOfChannel:self.channel] forKey:@"channel"];
    [result setValue:[NSString nameOfBank:self.bank] forKey:@"bank"];
    [result setValue:[NSString nameOfCreditCardTransactionType:self.type] forKey:@"type"];
    [result setValue:self.whiteListBins forKey:@"whitelist_bins"];
    [result setValue:[self.installment dictionaryValue] forKey:@"installment"];
    return @{@"credit_card": result};
}

- (instancetype)initWithTransactionType:(MIDCreditCardTransactionType)type
                           enableSecure:(BOOL)secure
                         enableSaveCard:(BOOL)saveCard
                          acquiringBank:(MIDAcquiringBank)bank
                       acquiringChannel:(MIDAcquiringChannel)channel
                            installment:(MIDCheckoutInstallment *)installment
                          whiteListBins:(NSArray <NSString *> *)bins {
    if (self = [super init]) {
        self.type = type;
        self.secure = secure;
        self.saveCard = saveCard;
        self.bank = bank;
        self.channel = channel;
        self.installment = installment;
        self.whiteListBins = bins;
    }
    return self;
}

@end
