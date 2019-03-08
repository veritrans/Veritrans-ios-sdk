//
//  MIDTrackingManager.m
//  MidtransCoreKit
//
//  Created by Vanbungkring on 2/2/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MIDUITrackingManager.h"
#import "MidtransPrivateConfig.h"
#import "MidtransConstant.h"

#import "MidtransNetworking.h"
#import "MidtransDeviceHelper.h"
#import "MidtransHelper.h"
#define timeStamp [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970] * 1000]

@implementation NSDictionary (MIDUITrackingManager)

- (NSMutableDictionary*)MIDUITrackingManageraddDefaultParameter{
    NSString *token = [PRIVATECONFIG mixpanelToken];
    NSMutableDictionary *defaultParameters = [NSMutableDictionary new];
    [defaultParameters setObject:[MidtransHelper nullifyIfNil:token] forKey:@"token"];
    [defaultParameters setObject:@"iOS" forKey:@"platform"];
    [defaultParameters setObject:[MidtransDeviceHelper currentCPUUsage] forKey:@"cpu"];
    [defaultParameters setObject:[MidtransDeviceHelper deviceCurrentNetwork] forKey:@"network"];
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

@implementation MIDUITrackingManager

+ (MIDUITrackingManager *)shared {
    static MIDUITrackingManager *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[MIDUITrackingManager alloc] init];
    });
    return sharedInstance;
}
- (void)trackEventName:(NSString *)eventName additionalParameters:(NSDictionary *)additionalParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters  = [parameters MIDUITrackingManageraddDefaultParameter];
    [parameters addEntriesFromDictionary:additionalParameters];
    NSDictionary *event = @{@"event":eventName,
                            @"properties":parameters};
    [self sendTrackingData:event];
    
}
- (void)trackEventName:(NSString *)eventName {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters  = [parameters MIDUITrackingManageraddDefaultParameter];
    NSDictionary *event = @{@"event":eventName,
                            @"properties":parameters};
    [self sendTrackingData:event];
    
}
- (void)sendTrackingData:(NSDictionary *)dictionary {
    NSData *decoded = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *base64String = [decoded base64EncodedStringWithOptions:0];
    NSString *URL = MIDTRANS_CORE_TRACKING_MIXPANEL_URL;
    NSDictionary *parameter = @{@"data":base64String};
    [self getFromURL:URL header:nil parameters:parameter callback:nil];
}

- (void)getFromURL:(NSString *)URL
            header:(NSDictionary *)header
        parameters:(NSDictionary *)parameters
          callback:(void(^)(id response, NSError *error))callback
{
    NSString *params = [parameters queryStringValue];
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", URL, params]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:120];
    [request addValue:@"mobile-ios" forHTTPHeaderField:@"X-Source"];
    [request addValue:@"ios" forHTTPHeaderField:@"X-Mobile-Platform"];
    [request addValue:MIDTRANS_SDK_CURRENT_VERSION forHTTPHeaderField:@"X-Source-Version"];
    
    for (NSString *key in [header allKeys]) {
        [request addValue:header[key] forHTTPHeaderField:key];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary *responseDictionary;
        
        if(httpResponse.statusCode == 200) {
            NSError *parseError = nil;
            responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        }
        
        if (callback) {
            callback(responseDictionary, error);
        }
    }];
    [dataTask resume];
}

@end

@implementation NSDictionary (parse)

- (NSString *)queryStringValue {
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [self keyEnumerator]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            [pairs addObjectsFromArray:[self pairsOfArray:value key:key]];
        } else {
            NSString *escapedValue;
            
            if ([value isKindOfClass:[NSNumber class]])
                escapedValue = value;
            else if ([value isKindOfClass:[NSNull class]])
                escapedValue = @"";
            else
                escapedValue = [value stringByRemovingPercentEncoding];
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escapedValue]];
        }
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSArray *)pairsOfArray:(NSArray *)values key:(NSString *)key {
    NSMutableArray *result = [NSMutableArray new];
    
    for (id value in values) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *pairs = [self pairsOfArray:value key:key];
            [result addObjectsFromArray:pairs];
        } else {
            NSString *escapedValue = [value isKindOfClass:[NSNumber class]] ? value : [value stringByRemovingPercentEncoding];
            [result addObject:[NSString stringWithFormat:@"%@[]=%@", key, escapedValue]];
        }
    }
    
    return result;
}

@end
