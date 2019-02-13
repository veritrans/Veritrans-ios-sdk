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
#import "MIDModelHelper.h"

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
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (void)request:(MIDNetworkService *)service completion:(void(^_Nullable)(id _Nullable response, NSError *_Nullable error))completion {
    NSURLRequest *request = [MIDRequestBuilder buildRequestFrom:service];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        NSInteger code = [(NSHTTPURLResponse *) response statusCode];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            
        } else {
            NSError *error;
            id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                });
                
            } else {
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseObject, error);
                    });
                    
                } else {
                    NSNumber *_serverStatusCode = responseObject[@"status_code"];
                    if (_serverStatusCode) {
                        code = [_serverStatusCode integerValue];
                    }
                    
                    BOOL isSuccess = (code >= 200) && (code < 300);
                    if (isSuccess) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(responseObject, nil);
                        });
                        
                    } else {
                        NSString *_message = @"Request failed.";
                        if (responseObject[@"error_message"]) {
                            _message = responseObject[@"error_message"];
                            
                        } else if (responseObject[@"status_message"]) {
                            _message = responseObject[@"status_message"];
                            
                        } else if (responseObject[@"error_messages"]) {
                            _message = responseObject[@"error_messages"];
                            
                        }
                        NSError *error = [NSError errorWithCode:code message:_message reasons:responseObject[@"validation_messages"]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(nil, error);
                        });
                    }
                }
            }
        }
    }];
    [task resume];
}

@end
