//
//  MidtransEnvironment.h
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 4/6/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#define VERSION @"1.0.0"

/**
 The payment server types.
 */
typedef NS_ENUM(NSUInteger, MIdtransServerEnvironment) {
    /**
     Sandbox payment environment. This server type should be used for testing.
     */
    MIdtransServerEnvironmentSandbox,
    
    /**
     Production payment environment. This server type should be used only when the product ready to be released.
     */
    MIdtransServerEnvironmentProduction,
    
    /**
     Unknown payment environment. Internal usage only.
     */
    MIdtransServerEnvironmentUnknown
};

