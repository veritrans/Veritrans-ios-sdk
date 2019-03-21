//
//  MIDVendorUI.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 13/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDVendorUI.h"
#import "MIDConstants.h"

@implementation MIDVendorUI

+ (MIDVendorUI *)shared {
    static MIDVendorUI *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (NSString *)mixpanelToken {
    switch (self.environment) {
        case MIDEnvironmentSandbox:
            return MIDTRANS_SANDBOX_MIXPANEL;
        case MIDEnvironmentProduction:
            return MIDTRANS_PRODUCTION_MIXPANEL;
        case MIDEnvironmentStaging:
            return MIDTRANS_STAGING_MIXPANEL;
    }
}

@end
