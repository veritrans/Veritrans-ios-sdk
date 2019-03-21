//
//  MIDConfig.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDConfig.h"

@implementation MIDConfig

+ (MIDConfig *)shared {
    static MIDConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestTimeout = 1000;
    }
    return self;
}

@end
