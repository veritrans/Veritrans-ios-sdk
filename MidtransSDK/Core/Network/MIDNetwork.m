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
#import "MIDNetworkHelper.h"

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
        
        NSInteger code = [(NSHTTPURLResponse *) response statusCode];
        
        
        if (error) {
            completion(nil, error);
        } else {
            NSError *error;
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                completion(nil, error);
            } else {
                BOOL isSuccess = (code >= 200) && (code < 300);
                if (isSuccess) {
                    completion(responseObject, nil);
                } else {
                    NSError *error = [NSError errorWithCode:code message:responseObject[@"error_messages"]];
                    completion(nil, error);
                }
            }
        }
    }];
    [task resume];
}

@end
