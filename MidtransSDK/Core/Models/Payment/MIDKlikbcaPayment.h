//
//  MIDKlikbcaPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayment.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDKlikbcaPayment : NSObject<MIDPayment>

@property (nonatomic) NSString *userID;

- (instancetype)initWithUserID:(NSString *)userID;

@end

NS_ASSUME_NONNULL_END
