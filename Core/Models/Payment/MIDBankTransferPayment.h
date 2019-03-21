//
//  MIDVirtualAccountPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayable.h"
#import "MIDModelEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDBankTransferPayment : NSObject<MIDPayable>

@property (nonatomic) MIDBankTransferType type;
@property (nonatomic, nullable) NSString *email;

- (instancetype)initWithType:(MIDBankTransferType)type email:(NSString *_Nullable)email;

@end

NS_ASSUME_NONNULL_END
