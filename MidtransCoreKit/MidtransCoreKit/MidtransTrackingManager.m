//
//  VTTrackingManager.m
//  MidtransCoreKit
//
//  Created by atta on 6/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransTrackingManager.h"
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

    [defaultParameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_SAVED_ID_TOKEN]?[[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_SAVED_ID_TOKEN]:@"-" forKey:MIDTRANS_TRACKING_SNAP_TOKEN_ID];
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

@implementation MidtransTrackingManager

+ (MidtransTrackingManager *)shared {
    static MidtransTrackingManager *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[MidtransTrackingManager alloc] init];
    });
    return sharedInstance;
}

- (void)trackTransaction:(BOOL)isSuccess
          secureProtocol:(BOOL)secure
      withPaymentFeature:(NSInteger)paymentFeature
           paymentMethod:(NSString *)paymentMethod
                   value:(NSNumber *)value {
    NSString *secureProtocol = secure ? @"true" : @"false";
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:secureProtocol forKey:MIDTRANS_TRACKING_SECURE_PROTOCOL];
    [parameters setObject:paymentMethod forKey:@"Payment Type"];
    NSDictionary *defaultParameters = [parameters addDefaultParameter];
    [parameters addEntriesFromDictionary:defaultParameters];
    NSDictionary *event = @{@"event":isSuccess?MIDTRANS_TRACKING_APP_TRANSACTION_SUCCESS:MIDTRANS_TRACKING_APP_TRANSACTION_ERROR,
                            @"properties":parameters};
    
    [self sendTrackingData:event];
}
- (void)trackAppSuccessGenerateToken:(NSString *)token
                      secureProtocol:(BOOL)secure
                  withPaymentFeature:(NSInteger)paymentFeature
                       paymentMethod:(NSString *)paymentMethod
                               value:(NSNumber *)value {
    NSString *secureProtocol = secure ? @"true" : @"false";
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:secureProtocol forKey:MIDTRANS_TRACKING_SECURE_PROTOCOL];
    [parameters setObject:paymentMethod forKey:@"Payment Type"];
    parameters  = [parameters addDefaultParameter];
    NSDictionary *event = @{@"event":MIDTRANS_TRACKING_APP_TOKENIZER_SUCCESS,
                            @"properties":parameters};
    
    [self sendTrackingData:event];
}
- (void)trackAppFailGenerateToken:(NSString *)token
                   secureProtocol:(BOOL)secure
               withPaymentFeature:(NSInteger)paymentFeature
                    paymentMethod:(NSString *)paymentMethod
                            value:(NSNumber *)value {
    NSString *secureProtocol = secure ? @"true" : @"false";
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters  = [parameters addDefaultParameter];
    [parameters setObject:secureProtocol forKey:MIDTRANS_TRACKING_SECURE_PROTOCOL];
    [parameters setObject:paymentMethod forKey:@"Payment Type"];
    NSDictionary *event = @{@"event":MIDTRANS_TRACKING_APP_TOKENIZER_ERROR,
                            @"properties":parameters};
    
    [self sendTrackingData:event];
}
- (void)trackEventWithEvent:(NSString *)eventName
             withProperties:(NSDictionary *)properties {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSDictionary *defaultParameters = [parameters addDefaultParameter];
    [parameters addEntriesFromDictionary:defaultParameters];
    [parameters addEntriesFromDictionary:properties];
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
- (void)trackGeneratedSnapToken:(BOOL)success {
    NSString *eventName = MIDTRANS_TRACKING_APP_GET_SNAP_TOKEN_SUCCESS;
    if (!success) {
        eventName = MIDTRANS_TRACKING_APP_GET_SNAP_TOKEN_FAIL;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters  = [parameters addDefaultParameter];
    NSDictionary *event = @{@"event":eventName,
                            @"properties":parameters};
    [self sendTrackingData:event];
}
- (void)trackPaymentlistGenerated:(NSArray *)paymentList {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters  = [parameters addDefaultParameter];
    [parameters setObject:paymentList forKey:@"Payment List"];
    NSDictionary *event = @{@"event":MIDTRANS_TRACKING_APP_GET_SNAP_PAYMENT_LIST,
                            @"properties":parameters};
    [self sendTrackingData:event];
}
- (void)sendSuccessTrackingWithParameters:(NSDictionary *)parameters {
}
@end
