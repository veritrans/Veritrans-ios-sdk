//
//  SNPErrorLogManager.m
//  MidtransCoreKit
//
//  Created by Vanbungkring on 10/10/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPErrorLogManager.h"
#import <Raygun4iOS/Raygun.h>
#import "MidtransConstant.h"
#import "MidtransDeviceHelper.h"
#define timeStamp [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970] * 1000]
@implementation SNPErrorLogManager
+ (SNPErrorLogManager *)shared {
    static SNPErrorLogManager *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[SNPErrorLogManager alloc] init];
        [Raygun sharedReporterWithApiKey:MIDTRANS_RAYGUN_APP_KEY];
       
    });
    return sharedInstance;
}
- (void)trackException:(NSException *)exceptionName className:(NSString *)className{
    self.className = className;
    
    NSMutableDictionary *defaultParameters = [NSMutableDictionary new];
    [defaultParameters setObject:timeStamp forKey:MIDTRANS_TRACKING_TIME_STAMP];
    [defaultParameters setObject:[MidtransDeviceHelper deviceToken]?[MidtransDeviceHelper deviceToken]:@"simulator" forKey:MIDTRANS_TRACKING_DEVICE_ID];
    [defaultParameters setObject:[MidtransDeviceHelper deviceModel]?[MidtransDeviceHelper deviceModel]:@"simulator" forKey:MIDTRANS_TRACKING_DEVICE_MODEL];
    [defaultParameters setObject:[MidtransDeviceHelper deviceName]?[MidtransDeviceHelper deviceName]:@"simulator" forKey:MIDTRANS_TRACKING_DEVICE_TYPE];
    [defaultParameters setObject:[MidtransDeviceHelper deviceLanguage] forKey:MIDTRANS_TRACKING_DEVICE_LANGUAGE];
    
    NSString *merchant = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_MERCHANT_NAME];
    [defaultParameters setObject:merchant forKey:MIDTRANS_CORE_MERCHANT_NAME];
    
    [[Raygun sharedReporter] send:exceptionName withTags:@[] withUserCustomData:defaultParameters];
}

@end
