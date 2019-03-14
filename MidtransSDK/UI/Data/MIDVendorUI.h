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

@property (nonatomic) MIDEnvironment environment;
@property (nonatomic) MIDPaymentInfo *info;
@property (nonatomic) NSString *snapToken;
@property (nonatomic) NSString *userID;

+ (MIDVendorUI *)shared;

- (NSString *)mixpanelToken;

@end

NS_ASSUME_NONNULL_END
