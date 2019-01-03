//
//  MIDCreditCardInstallment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 27/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDChargeInstallment.h"
#import "MIDModelHelper.h"

@interface MIDChargeInstallment()

@property (nonatomic) MIDAcquiringBank bank;
@property (nonatomic) NSInteger term;

@end

@implementation MIDChargeInstallment

+ (instancetype)modelWithBank:(MIDAcquiringBank)bank term:(NSInteger)term {
    MIDChargeInstallment *obj = [MIDChargeInstallment new];
    obj.bank = bank;
    obj.term = term;
    return obj;
}

- (NSString *)value {
    return [NSString stringWithFormat:@"%@_%ld", [NSString nameOfBank:self.bank], (long)self.term];
}

@end
