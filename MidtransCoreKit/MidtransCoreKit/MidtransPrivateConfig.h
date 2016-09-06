//
//  VTPrivateConfig.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTEnvironment.h"

#define PRIVATECONFIG (MidtransPrivateConfig *)[MidtransPrivateConfig sharedInstance]

@interface MidtransPrivateConfig : NSObject

@property (nonatomic, readonly) NSString *baseUrl;
@property (nonatomic, readonly) NSString *mixpanelToken;
@property (nonatomic, readonly) NSString *snapURL;

+ (void)setServerEnvironment:(VTServerEnvironment)environment;
+ (id)sharedInstance;

@end
