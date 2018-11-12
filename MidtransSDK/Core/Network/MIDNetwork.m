//
//  MIDNetwork.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDNetwork.h"
#import "MIDNetworkConstants.h"
#import "MIDRequestBuilder.h"

@implementation MIDNetwork {
    NSURLSession *session;
}

+ (MIDNetwork *)shared {
    static MIDNetwork *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    if (self = [super init]) {
        session = [NSURLSession sharedSession];
    }
    return self;
}

- (void)request:(MIDNetworkService *)service completion:(void(^_Nullable)(id _Nullable response, NSError * _Nullable error))completion {
    NSURLRequest *request = [MIDRequestBuilder buildRequestFrom:service];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
        } else {
            NSError *error;
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                completion(nil, error);
            } else {
                completion(responseObject, nil);
            }
        }
    }];
    [task resume];
}

@end
