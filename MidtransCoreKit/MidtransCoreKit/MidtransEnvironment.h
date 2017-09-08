//
//  MidtransEnvironment.h
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 4/6/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#define VERSION @"1.5.0"

/**
 The payment server types.
 */
typedef NS_ENUM(NSUInteger, MidtransServerEnvironment) {
    /**
     Sandbox payment environment. This server type should be used for testing.
     */
    MidtransServerEnvironmentSandbox,


    MidtransServerEnvironmentStaging,
    /**
     Production payment environment. This server type should be used only when the product ready to be released.
     */
    MidtransServerEnvironmentProduction,
    
    /**
     Unknown payment environment. Internal usage only.
     */
    MidtransServerEnvironmentUnknown
};

