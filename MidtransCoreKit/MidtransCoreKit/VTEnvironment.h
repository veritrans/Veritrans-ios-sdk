//
//  VTEnvironment.h
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 4/6/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#define VERSION @"0.1"

/**
 The payment server types.
 */
typedef NS_ENUM(NSUInteger, VTServerEnvironment) {
    /**
     Sandbox payment environment. This server type should be used for testing.
     */
    VTServerEnvironmentSandbox,
    
    /**
     Production payment environment. This server type should be used only when the product ready to be released.
     */
    VTServerEnvironmentProduction,
    
    /**
     Unknown payment environment. Internal usage only.
     */
    VTServerEnvironmentUnknown
};

