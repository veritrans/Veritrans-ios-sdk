//
//  VTCardConfig.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCardControllerConfig.h"

@implementation VTCardControllerConfig

- (BOOL)enableOneClick {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"vt_enable_oneclick"] boolValue];
}

- (void)setEnableOneClick:(BOOL)enableOneClick {
    [[NSUserDefaults standardUserDefaults] setObject:@(enableOneClick) forKey:@"vt_enable_oneclick"];
}

- (BOOL)enable3DSecure {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"vt_enable_3dsecure"] boolValue];
}
- (void)setEnable3DSecure:(BOOL)enable3DSecure {
    [[NSUserDefaults standardUserDefaults] setObject:@(enable3DSecure) forKey:@"vt_enable_3dsecure"];
}

+ (id)sharedInstance {
    static VTCardControllerConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

@end
