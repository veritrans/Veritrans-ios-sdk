//
//  MIDTokenizeConfig.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 27/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDModelEnums.h"

@interface MIDTokenizeConfig : NSObject

@property (nonatomic) NSNumber *grossAmount;
@property (nonatomic) NSInteger installmentTerm;

@property (nonatomic) BOOL enable3ds;
@property (nonatomic) BOOL enablePoint;

@property (nonatomic) MIDAcquiringBank bank;
@property (nonatomic) MIDCreditCardTransactionType type;
@property (nonatomic) MIDCurrency currency;
@property (nonatomic) MIDAcquiringChannel channel;

@end
