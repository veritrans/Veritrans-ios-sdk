//
//  MIDTrackingManager.m
//  MidtransCoreKit
//
//  Created by Vanbungkring on 2/2/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "SNPUITrackingManager.h"
#import "MidtransPrivateConfig.h"
#import "MidtransConstant.h"

#import "MidtransNetworking.h"
#import "MidtransDeviceHelper.h"
#import "MidtransHelper.h"
#define timeStamp [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970] * 1000]

@implementation NSDictionary (SNPUITrackingManager)

- (NSMutableDictionary*)SNPUITrackingManageraddDefaultParameter{
    NSString *token = [PRIVATECONFIG mixpanelToken];
    NSMutableDictionary *defaultParameters = [NSMutableDictionary new];
    [defaultParameters setObject:[MidtransHelper nullifyIfNil:token] forKey:@"token"];
    [defaultParameters setObject:@"iOS" forKey:@"platform"];
    [defaultParameters setObject:[MidtransDeviceHelper currentCPUUsage] forKey:@"cpu"];
    [defaultParameters setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"sdk version"];
    [defaultParameters setObject:[MidtransDeviceHelper applicationName]?[MidtransDeviceHelper applicationName]:@"-" forKey:@"host_app"];
    
    [defaultParameters setObject:[NSString stringWithFormat:@"width = %f, height = %f", [MidtransDeviceHelper screenSize].width, [MidtransDeviceHelper screenSize].height] forKey:@"screen_size"];
    
    [defaultParameters setObject:[[UIDevice currentDevice] systemVersion] forKey:@"os_version"];
    id snapToken = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_SAVED_ID_TOKEN];
    if (snapToken) {
        [defaultParameters setObject:snapToken forKey:MIDTRANS_TRACKING_DISTINCT_ID];
    }
    else {
        [defaultParameters setObject:@"unknown" forKey:MIDTRANS_TRACKING_DISTINCT_ID];
    }
    [defaultParameters setObject:timeStamp forKey:MIDTRANS_TRACKING_TIME_STAMP];
    [defaultParameters setObject:[MidtransDeviceHelper deviceToken]?[MidtransDeviceHelper deviceToken]:@"simulator" forKey:MIDTRANS_TRACKING_DEVICE_ID];
    [defaultParameters setObject:[MidtransDeviceHelper deviceModel]?[MidtransDeviceHelper deviceModel]:@"simulator" forKey:MIDTRANS_TRACKING_DEVICE_MODEL];
    [defaultParameters setObject:[MidtransDeviceHelper deviceName]?[MidtransDeviceHelper deviceName]:@"simulator" forKey:MIDTRANS_TRACKING_DEVICE_TYPE];
    [defaultParameters setObject:[MidtransDeviceHelper deviceLanguage] forKey:MIDTRANS_TRACKING_DEVICE_LANGUAGE];
    NSString *merchant = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_MERCHANT_NAME];
    if (merchant.length) {
        [defaultParameters setObject:merchant forKey:@"merchant"];
    }
    NSString *merchantId = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_TRACKING_MERCHANT_ID];
    if (merchantId.length) {
        [defaultParameters setObject:merchantId forKey:@"merchant_id"];
    }
    NSArray *enabledPayments = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_TRACKING_ENABLED_PAYMENTS];
    if (enabledPayments) {
        [defaultParameters setObject:enabledPayments forKey:@"enabled payments"];
    }
    return defaultParameters;
}

@end

@implementation SNPUITrackingManager

+ (SNPUITrackingManager *)shared {
    static SNPUITrackingManager *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[SNPUITrackingManager alloc] init];
    });
    return sharedInstance;
}
- (void)trackEventName:(NSString *)eventName additionalParameters:(NSDictionary *)additionalParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters  = [parameters SNPUITrackingManageraddDefaultParameter];
    [parameters addEntriesFromDictionary:additionalParameters];
    NSDictionary *event = @{@"event":eventName,
                            @"properties":parameters};
    [self sendTrackingData:event];
    
}
- (void)trackEventName:(NSString *)eventName {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters  = [parameters SNPUITrackingManageraddDefaultParameter];
    NSDictionary *event = @{@"event":eventName,
                            @"properties":parameters};
    [self sendTrackingData:event];
    
}
- (void)sendTrackingData:(NSDictionary *)dictionary {
    NSData *decoded = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *base64String = [decoded base64EncodedStringWithOptions:0];
    NSString *URL = MIDTRANS_CORE_TRACKING_MIXPANEL_URL;
    NSDictionary *parameter = @{@"data":base64String};
    [[MidtransNetworking shared] getFromURL:URL parameters:parameter callback:nil];
    
}
@end
