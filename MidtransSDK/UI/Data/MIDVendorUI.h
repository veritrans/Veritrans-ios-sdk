//
//  MIDVendorUI.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 13/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDVendorUI : NSObject

@property (nonatomic) MIDPaymentInfo *info;

+ (MIDVendorUI *)shared;

@end

NS_ASSUME_NONNULL_END
