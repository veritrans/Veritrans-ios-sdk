//
//  MIDCreditCardInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"
#import "MIDSavedCardInfo.h"
#import "MIDModelEnums.h"
#import "MIDInstallmentInfo.h"

@interface MIDCreditCardInfo : NSObject <MIDMappable>

@property (nonatomic) NSArray <MIDSavedCardInfo *> *savedCards;
@property (nonatomic) NSArray <NSString *> *blacklistBins;
@property (nonatomic) NSArray <NSString *> *whitelistBins;
@property (nonatomic) MIDInstallmentInfo *installment;
@property (nonatomic) BOOL saveCard;
@property (nonatomic) BOOL secure;
@property (nonatomic) BOOL merchantSaveCard;
@property (nonatomic) MIDCreditCardTransactionType type;

@end
