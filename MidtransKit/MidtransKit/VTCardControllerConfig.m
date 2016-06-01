//
//  VTCardConfig.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCardControllerConfig.h"

@implementation VTCardControllerConfig

+ (id)sharedInstance {
    static VTCardControllerConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

@end
