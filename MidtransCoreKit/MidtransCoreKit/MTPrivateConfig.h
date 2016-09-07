//
//  MTPrivateConfig.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTEnvironment.h"

#define PRIVATECONFIG (MTPrivateConfig *)[MTPrivateConfig sharedInstance]

@interface MTPrivateConfig : NSObject

@property (nonatomic, readonly) NSString *baseUrl;
@property (nonatomic, readonly) NSString *mixpanelToken;
@property (nonatomic, readonly) NSString *snapURL;

+ (void)setServerEnvironment:(MTServerEnvironment)environment;
+ (id)sharedInstance;

@end
