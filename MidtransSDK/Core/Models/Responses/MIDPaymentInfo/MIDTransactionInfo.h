//
//  MIDTransactionInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface MIDTransactionInfo : NSObject <MIDMappable>

@property (nonatomic) NSString *currency;
@property (nonatomic) NSNumber *grossAmount;
@property (nonatomic) NSString *orderID;

@end
