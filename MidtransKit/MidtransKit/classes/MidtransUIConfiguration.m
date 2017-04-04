//
//  MidtransUIConfiguration.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 12/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIConfiguration.h"

@implementation MidtransUIConfiguration

+ (MidtransUIConfiguration *)shared {
    static MidtransUIConfiguration *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

@end
