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
    [result setValue:[NSString stringFromBool:self.secure] forKey:@"secure"];
    [result setValue:[NSString nameOfChannel:self.channel] forKey:@"channel"];
    [result setValue:[NSString nameOfBank:self.bank] forKey:@"bank"];
    [result setValue:[NSString nameOfCreditCardTransactionType:self.type] forKey:@"type"];
    [result setValue:self.whiteListBins forKey:@"whitelist_bins"];
    [result setValue:self.blackListBins forKey:@"blacklist_bins"];
    [result setValue:[self.installment dictionaryValue] forKey:@"installment"];
    [result setValue:@YES forKey:@"save_card"];
    return @{@"credit_card": result};
}

+ (instancetype)modelWithTransactionType:(MIDCreditCardTransactionType)type
                            enableSecure:(BOOL)secure
                           acquiringBank:(MIDAcquiringBank)bank
                        acquiringChannel:(MIDAcquiringChannel)channel
                             installment:(MIDCheckoutInstallment *)installment
                           whiteListBins:(NSArray<NSString *> *)whiteListBins
                           blackListBins:(NSArray<NSString *> *)blackListBins {    
    MIDCheckoutCreditCard *obj = [MIDCheckoutCreditCard new];
    obj.type = type;
    obj.secure = secure;
    obj.bank = bank;
    obj.channel = channel;
    obj.installment = installment;
    obj.whiteListBins = whiteListBins;
    obj.blackListBins = blackListBins;
    return obj;
}

@end
