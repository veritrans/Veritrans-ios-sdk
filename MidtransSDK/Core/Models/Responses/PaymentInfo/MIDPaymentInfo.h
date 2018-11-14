//
//  MIDPaymentInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"
#import "MIDCallbackInfo.h"
#import "MIDCreditCardInfo.h"
#import "MIDMerchantInfo.h"
#import "MIDPromoInfo.h"
#import "MIDTransactionInfo.h"
#import "MIDPaymentMethodInfo.h"

@interface MIDPaymentInfo : NSObject <MIDMappable>

@property (nonatomic) MIDCallbackInfo *callbacks;
@property (nonatomic) MIDCreditCardInfo *creditCard;
@property (nonatomic) MIDMerchantInfo *merchant;
@property (nonatomic) MIDPromoInfo *promo;
@property (nonatomic) NSString *token;
@property (nonatomic) MIDTransactionInfo *transaction;
@property (nonatomic) NSArray <MIDPaymentMethodInfo *> *enabledPayments;

@end
