//
//  MIDClient.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDClient.h"
#import "MIDVendor.h"
#import "MIDNetworkService.h"
#import "MIDVendor.h"
#import "MIDNetwork.h"

@interface MIDClient()
@property (readwrite, nonnull) NSString *clientKey;
@property (readwrite, nonnull) NSString *merchantServerURL;
@property (readwrite) MIDEnvironment environment;
@end

@implementation MIDClient

+ (MIDClient *)shared {
    static MIDClient *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //set default env
        [[MIDVendor shared] applyEnvironment:MIDEnvironmentSandbox];
    }
    return self;
}

- (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MIDEnvironment)environment {
    
    self.clientKey = clientKey;
    self.merchantServerURL = merchantServerURL;
    self.environment = environment;
    
    [[MIDVendor shared] applyEnvironment:environment];
}

- (void)checkoutWith:(MIDCheckoutRequest *)request
          completion:(void (^_Nullable) (MIDToken *_Nullable token, NSError *_Nullable error))completion {
    NSDictionary *params = [request dictionaryValue];
    MIDNetworkService *service = [[MIDNetworkService alloc] initWithBaseURL:self.merchantServerURL
                                                                       path:@"/charge"
                                                                     method:MIDNetworkMethodPOST
                                                                 parameters:params];
    [[MIDNetwork shared] request:service completion:^(id  _Nullable response, NSError * _Nullable error) {
        if (response) {
            MIDToken *token = [[MIDToken alloc] initWithDictionary:response];
            completion(token, nil);
        } else {
            completion(nil, error);
        }
    }];
}

- (void)fetchPaymentInformationWithToken:(NSString *)token
                              completion:(void (^_Nullable) (MIDPaymentInfo *_Nullable info, NSError *_Nullable error))completion {
    NSString *path = [NSString stringWithFormat:@"/transactions/%@", token];
    MIDNetworkService *service = [[MIDNetworkService alloc] initWithBaseURL:[MIDVendor shared].snapURL
                                                                       path:path
                                                                     method:MIDNetworkMethodGET
                                                                 parameters:nil];
    [[MIDNetwork shared] request:service completion:^(id  _Nullable response, NSError * _Nullable error) {
        if (response) {
            MIDPaymentInfo *info = [[MIDPaymentInfo alloc] initWithDictionary:response];
            completion(info, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
