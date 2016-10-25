//
//  MidtransPrivateConfig.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransEnvironment.h"

#define PRIVATECONFIG (MidtransPrivateConfig *)[MidtransPrivateConfig shared]

@interface MidtransPrivateConfig : NSObject

@property (nonatomic, readonly) NSString *baseUrl;
@property (nonatomic, readonly) NSString *mixpanelToken;
@property (nonatomic, readonly) NSString *snapURL;

+ (void)setServerEnvironment:(MIdtransServerEnvironment)environment;
+ (MidtransPrivateConfig *)shared;

@end
