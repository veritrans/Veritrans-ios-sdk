//
//  MIDCreditCardInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface MIDCreditCardInfo : NSObject <MIDMappable>

@property (nonatomic) NSArray <NSString *> *blacklistBins;
@property (nonatomic) NSArray <NSString *> *whitelistBins;
@property (nonatomic) NSNumber *saveCard;
@property (nonatomic) NSNumber *secure;
@property (nonatomic) NSNumber *merchantSaveCard;

@end
