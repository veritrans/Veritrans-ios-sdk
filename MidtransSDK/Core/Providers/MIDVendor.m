//
//  MIDVendor.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDVendor.h"
#import "MIDNetworkConstants.h"

@interface MIDVendor ()
@property (readwrite) NSString *snapURL;
@end

@implementation MIDVendor

+ (MIDVendor *)shared {
    static MIDVendor *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)applyEnvironment:(MIDEnvironment)env {
    switch (env) {
        case MIDEnvironmentSandbox:
            self.snapURL = SNAP_SANDBOX;
            break;
        case MIDEnvironmentStaging:
            self.snapURL = SNAP_STAGGING;
        default:
            self.snapURL = SNAP_PROD;
            break;
    }
}

@end
