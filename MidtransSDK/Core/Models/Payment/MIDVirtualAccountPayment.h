//
//  MIDVirtualAccountPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayment.h"
#import "MIDModelEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDVirtualAccountPayment : NSObject<MIDPayment>

@property (nonatomic) MIDVirtualAccountType type;
@property (nonatomic, nullable) NSString *email;

- (instancetype)initWithType:(MIDVirtualAccountType)type email:(NSString * _Nullable)email;

@end

NS_ASSUME_NONNULL_END
