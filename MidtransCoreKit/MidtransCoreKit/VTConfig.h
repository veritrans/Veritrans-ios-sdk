//
//  VTConfig.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const VTEnvironmentSandbox;
extern NSString *const VTEnvironmentProduction;

@interface VTConfig : NSObject

+ (id)sharedInstance;
+ (instancetype)configWithClientKey:(NSString *)clientKey merchantServerURL:(NSString *)merchantServerURL environment:(NSString *)environment;

@property (nonatomic, readonly) NSString *baseUrl;
@property (nonatomic, readonly) NSString *clientKey;
@property (nonatomic, readonly) NSString *merchantServerURL;

@end