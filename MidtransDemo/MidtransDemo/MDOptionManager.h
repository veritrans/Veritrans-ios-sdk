//
//  MDOptionManager.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/27/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDOption.h"

@interface MDOptionManager : NSObject

+ (MDOptionManager *)shared;

@property (nonatomic) MDOption *ccTypeOption;
@property (nonatomic) MDOption *secure3DOption;
@property (nonatomic) MDOption *issuingBankOption;
@property (nonatomic) MDOption *expireTimeOption;
@property (nonatomic) MDOption *saveCardOption;
@property (nonatomic) MDOption *promoOption;
@property (nonatomic) MDOption *preauthOption;
@property (nonatomic) MDOption *colorOption;
@property (nonatomic) MDOption *bniPointOption;
@property (nonatomic) MDOption *permataVAOption;
@property (nonatomic) MDOption *bcaVAOption;
@property (nonatomic) MDOption *installmentOption;
@property (nonatomic) MDOption *paymentChannel;
- (void)resetConfiguration;
@end
