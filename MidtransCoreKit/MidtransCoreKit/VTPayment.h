//
//  VTPayment.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTUser.h"
#import "VTItem.h"

@interface VTPayment : NSObject

@property (nonatomic, readonly) VTUser *user;
@property (nonatomic, readonly) NSArray <VTItem *> *items;
@property (nonatomic, readonly) NSNumber *totalPayment;
@property (nonatomic, readonly) NSString *orderId;
@property (nonatomic, readonly) NSNumber *amount;

- (id)initWithUser:(VTUser *)user amount:(NSNumber *)amount;

- (NSDictionary *)transactionDetail;

@end
