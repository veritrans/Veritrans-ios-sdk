//
//  MidtransTrackingManager.m
//  MidtransCoreKit
//
//  Created by atta on 6/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransTrackingManager.h"
#import "MidtransPrivateConfig.h"
#import "VTConstant.h"
#import "PaymentRequestDataModels.h"
#import "MidtransNetworking.h"
#import "VTCreditCardPaymentFeature.h"

@implementation NSDictionary (TrackingManager)

- (NSDictionary*)dictionaryByRemovingKey:(NSString *)key {
    NSMutableDictionary *result = [self mutableCopy];
    [result removeObjectForKey:key];
    return result;
}

- (NSMutableDictionary*)addDefaultParameter{
    NSMutableDictionary *defaultParameters = [NSMutableDictionary new];
    [defaultParameters setObject:[PRIVATECONFIG mixpanelToken] forKey:@"token"];
    [defaultParameters setObject:@"iOS" forKey:@"platform"];
    [defaultParameters setObject:VERSION forKey:@"sdkVersion"];
    [defaultParameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:VT_CORE_MERCHANT_NAME] forKey:@"merchant"];
    
    return defaultParameters;
}

@end

@implementation MidtransTrackingManager

+ (MidtransTrackingManager *)sharedInstance {
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
    [parameters setObject:secureProtocol forKey:VT_TRACKING_SECURE_PROTOCOL];
    [parameters setObject:paymentMethod forKey:@"Payment Type"];
    parameters  = [parameters addDefaultParameter];
    NSDictionary *event = @{@"event":isSuccess?VT_TRACKING_APP_TRANSACTION_SUCCESS:VT_TRACKING_APP_TRANSACTION_ERROR,
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
    [parameters setObject:secureProtocol forKey:VT_TRACKING_SECURE_PROTOCOL];
    [parameters setObject:paymentMethod forKey:@"Payment Type"];
    parameters  = [parameters addDefaultParameter];
    NSDictionary *event = @{@"event":VT_TRACKING_APP_TOKENIZER_SUCCESS,
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
    [parameters setObject:secureProtocol forKey:VT_TRACKING_SECURE_PROTOCOL];
    [parameters setObject:paymentMethod forKey:@"Payment Type"];
    parameters  = [parameters addDefaultParameter];
    NSDictionary *event = @{@"event":VT_TRACKING_APP_TOKENIZER_ERROR,
                            @"properties":parameters};
    
    [self sendTrackingData:event];
}
- (void)sendTrackingData:(NSDictionary *)dictionary {
    
    NSData *decoded = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *base64String = [decoded base64EncodedStringWithOptions:0];
    
    NSString *URL = @"https://api.mixpanel.com/track";
    NSDictionary *parameter = @{@"data":base64String};
    [[MidtransNetworking sharedInstance] getFromURL:URL parameters:parameter callback:nil];
    
}
- (void)trackGeneratedSnapToken:(BOOL)success {
    NSString *eventName = VT_TRACKING_APP_GET_SNAP_TOKEN_SUCCESS;
    if (success) {
        eventName = VT_TRACKING_APP_GET_SNAP_TOKEN_FAIL;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters  = [parameters addDefaultParameter];
    NSDictionary *event = @{@"event":VT_TRACKING_APP_TOKENIZER_ERROR,
                            @"properties":parameters};
    [self sendTrackingData:event];
}
- (void)sendSuccessTrackingWithParameters:(NSDictionary *)parameters {
}
@end
