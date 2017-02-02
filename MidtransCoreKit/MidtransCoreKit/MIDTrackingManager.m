//
//  MIDTrackingManager.m
//  MidtransCoreKit
//
//  Created by Vanbungkring on 2/2/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MIDTrackingManager.h"
#import "MidtransPrivateConfig.h"
#import "MidtransConstant.h"
#import "MTPaymentRequestDataModels.h"
#import "MidtransNetworking.h"
#import "MidtransCreditCardPaymentFeature.h"
#import "MidtransDeviceHelper.h"
#import "MidtransHelper.h"

@implementation NSDictionary (TrackingManager)

- (NSDictionary*)dictionaryByRemovingKey:(NSString *)key {
    NSMutableDictionary *result = [self mutableCopy];
    [result removeObjectForKey:key];
    return result;
}

- (NSMutableDictionary*)addDefaultParameter{
    NSString *token = [PRIVATECONFIG mixpanelToken];
    
    NSMutableDictionary *defaultParameters = [NSMutableDictionary new];
    [defaultParameters setObject:[MidtransHelper nullifyIfNil:token] forKey:@"token"];
    [defaultParameters setObject:@"iOS" forKey:@"Platform"];
    [defaultParameters setObject:VERSION forKey:@"SDK Version"];
    
    id snapToken = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_SAVED_ID_TOKEN];
    if (snapToken) {
        [defaultParameters setObject:snapToken forKey:MIDTRANS_TRACKING_DISTINCT_ID];
    }
    else {
        [defaultParameters setObject:@"unknown" forKey:MIDTRANS_TRACKING_DISTINCT_ID];
    }
    
    [defaultParameters setObject:[MidtransDeviceHelper deviceToken]?[MidtransDeviceHelper deviceToken]:@"simulator" forKey:MIDTRANS_TRACKING_DEVICE_ID];
    [defaultParameters setObject:[MidtransDeviceHelper deviceModel]?[MidtransDeviceHelper deviceModel]:@"simulator" forKey:MIDTRANS_TRACKING_DEVICE_MODEL];
    [defaultParameters setObject:[MidtransDeviceHelper deviceLanguage] forKey:MIDTRANS_TRACKING_DEVICE_LANGUAGE];
    NSString *merchant = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_MERCHANT_NAME];
    if (merchant.length) {
        [defaultParameters setObject:merchant forKey:@"Merchant"];
    }
    return defaultParameters;
}

@end

@implementation MIDTrackingManager

+ (MIDTrackingManager *)shared {
    static MIDTrackingManager *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[MIDTrackingManager alloc] init];
    });
    return sharedInstance;
}

@end
