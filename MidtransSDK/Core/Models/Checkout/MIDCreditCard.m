//
//  MIDCreditCardOption.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCreditCard.h"
#import "MIDModelHelper.h"

@implementation MIDCreditCard

- (nonnull NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];    
    [result setValue:@(self.secureEnabled) forKey:@"secure"];
    [result setValue:[NSString nameOfAuth:self.authentication] forKey:@"authentication"];
    [result setValue:[NSString nameOfChannel:self.channel] forKey:@"channel"];
    [result setValue:[NSString nameOfBank:self.bank] forKey:@"bank"];
    [result setValue:[NSString nameOfCreditCardTransactionType:self.type] forKey:@"type"];
    [result setValue:self.whiteListBins forKey:@"whitelist_bins"];
    [result setValue:self.blackListBins forKey:@"blacklist_bins"];
    [result setValue:[self.installment dictionaryValue] forKey:@"installment"];
    [result setValue:@YES forKey:@"save_card"];
    return @{@"credit_card": result};
}

- (instancetype _Nonnull)initWithCreditCardTransactionType:(MIDCreditCardTransactionType)type
                                            authentication:(MIDAuthentication)authentication
                                             acquiringBank:(MIDAcquiringBank)bank
                                          acquiringChannel:(MIDAcquiringChannel)channel
                                               installment:(MIDInstallment *)installment
                                             whiteListBins:(NSArray <NSString *> *)whiteListBins
                                             blackListBins:(NSArray <NSString *> *)blackListBins {
    if (self = [super init]) {
        self.type = type;
        self.authentication = authentication;
        self.bank = bank;
        self.channel = channel;
        self.installment = installment;
        self.whiteListBins = whiteListBins;
        self.blackListBins = blackListBins;
    }
    return self;
}

- (BOOL)secureEnabled {
    switch (self.authentication) {
        case MIDAuthentication3DS:
            return YES;
            
        default:
            return NO;
    }
}

@end
