//
//  MIDPointResponse.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDPointResponse : NSObject <MIDMappable>

@property (nonatomic) NSString *balance;
@property (nonatomic) NSString *balanceAmount;
@property (nonatomic) NSString *balanceQuantity;
@property (nonatomic) NSString *statusCode;
@property (nonatomic) NSString *statusMessage;
@property (nonatomic) NSString *transactionTime;

@end

NS_ASSUME_NONNULL_END
