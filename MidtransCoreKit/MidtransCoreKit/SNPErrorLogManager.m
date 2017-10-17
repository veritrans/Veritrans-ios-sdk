//
//  SNPErrorLogManager.m
//  MidtransCoreKit
//
//  Created by Vanbungkring on 10/10/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPErrorLogManager.h"
#import <Raygun4iOS/Raygun.h>
#import <UIKit/UIKit.h>
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
+ (NSString *)applicationName {
    return (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)applicationVersion {
    return (NSString *)[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

- (void)trackException:(NSException *)exceptionName className:(NSString *)className{
    self.className = className;
    
    NSMutableDictionary *defaultParameters = [NSMutableDictionary new];
    [defaultParameters setObject:@"iOS" forKey:@"platform"];
    [defaultParameters setObject:[MidtransDeviceHelper currentCPUUsage] forKey:@"cpu"];
    [defaultParameters setObject:[MidtransDeviceHelper deviceCurrentNetwork] forKey:@"network"];
    [defaultParameters setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"sdk version"];
    [defaultParameters setObject:[MidtransDeviceHelper applicationName] forKey:@"host_app"];
    
    [defaultParameters setObject:[NSString stringWithFormat:@"width = %f, height = %f", [MidtransDeviceHelper screenSize].width, [MidtransDeviceHelper screenSize].height] forKey:@"screen_size"];
    
    [defaultParameters setObject:[[UIDevice currentDevice] systemVersion] forKey:@"os_version"];
    [defaultParameters setObject:self.className?self.className:@"-" forKey:@"class"];
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
