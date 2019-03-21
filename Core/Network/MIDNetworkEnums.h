//
//  MIDNetworkEnums.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MIDEnvironment) {
    MIDEnvironmentSandbox,
    MIDEnvironmentStaging,
    MIDEnvironmentProduction
};

typedef NS_ENUM(NSUInteger, MIDHTTPMethod) {
    MIDNetworkMethodGET,
    MIDNetworkMethodPOST,
    MIDNetworkMethodDELETE
};
