//
//  MIDMerchantInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"
#import "MIDNotificationSettingsInfo.h"
#import "MIDPreferenceInfo.h"

@interface MIDMerchantInfo : NSObject <MIDMappable>

@property (nonatomic) NSArray <NSString *> *acquiringBanks;
@property (nonatomic) NSArray <NSString *> *enabledPrinciples;
@property (nonatomic) NSArray <NSString *> *pointBanks;
@property (nonatomic) NSString *clientKey;
@property (nonatomic) NSString *merchantID;
@property (nonatomic) MIDNotificationSettingsInfo *notifSettings;
@property (nonatomic) MIDPreferenceInfo *preference;

@end
