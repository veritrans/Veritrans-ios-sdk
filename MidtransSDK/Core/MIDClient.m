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
#import "MIDNetwork.h"
#import "MIDNetworkHelper.h"

@interface MIDClient()
@property (readwrite, nonnull) NSString *clientKey;
@property (readwrite, nonnull) NSString *merchantServerURL;
@property (readwrite) MIDEnvironment environment;
@end

@implementation MIDClient

+ (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MIDEnvironment)environment {
    [MIDVendor shared].clientKey = clientKey;
    [MIDVendor shared].environment = environment;
    [MIDVendor shared].merchantURL = merchantServerURL;
}

+ (void)checkoutWith:(MIDCheckoutTransaction *)transaction
             options:(NSArray <NSObject <MIDCheckoutable>*> *_Nullable)options
          completion:(void (^_Nullable) (MIDToken *_Nullable token, NSError *_Nullable error))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:transaction.dictionaryValue];
    for (id option in options) {
        [params addEntriesFromDictionary:[option dictionaryValue]];
    }
    MIDNetworkService *service = [[MIDNetworkService alloc] initWithBaseURL:[MIDVendor shared].merchantURL
                                                                       path:@"/charge"
                                                                     method:MIDNetworkMethodPOST
                                                                 parameters:params];
    [[MIDNetwork shared] request:service completion:^(id  _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDToken *token = [[MIDToken alloc] initWithDictionary:response];
            completion(token, nil);
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)getPaymentInfoWithToken:(NSString *)token
                     completion:(void (^_Nullable) (MIDPaymentInfo *_Nullable info, NSError *_Nullable error))completion {
    if (token.length == 0) {
        [NSException raise:@"MIDInvalidParameterException" format:@"Your token is empty."];
    }
    
    NSString *path = [NSString stringWithFormat:@"/transactions/%@", token];
    MIDNetworkService *service = [[MIDNetworkService alloc] initWithBaseURL:[MIDVendor shared].snapURL
                                                                       path:path
                                                                     method:MIDNetworkMethodGET
                                                                 parameters:nil];
    [[MIDNetwork shared] request:service completion:^(id  _Nullable response, NSError *_Nullable error) {
        if (response) {
            MIDPaymentInfo *info = [[MIDPaymentInfo alloc] initWithDictionary:response];
            completion(info, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
