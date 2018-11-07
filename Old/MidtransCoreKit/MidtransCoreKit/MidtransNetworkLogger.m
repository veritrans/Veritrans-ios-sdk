//
//  MidtransNetworkLogger.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 1/26/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransNetworkLogger.h"
#import "MidtransNetworking.h"

@implementation MidtransNetworkLogger

+ (MidtransNetworkLogger *)shared {
    static MidtransNetworkLogger *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}


- (void)startLogging {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDidStart:) name:MTNetworkingDidStartRequest object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDidFinish:) name:MTNetworkingDidFinishRequest object:nil];
}

- (void)stopLogging {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestDidStart:(NSNotification *)notification {
    NSURLRequest *request = [notification.object networkRequest];
    NSLog(@"%@ to : %@", request.HTTPMethod, request.URL);
    
    id body = request.HTTPBody;
    if (body) {
        NSLog(@"body : %@", [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    }
}

- (void)requestDidFinish:(NSNotification *)notification {
    NSError *error = [notification.object networkError];
    if (error) {
        NSLog(@"error : %@", error);
    }
    else {
        id response = [notification.object networkResponse];
        if (response) {
            NSLog(@"response : %@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        }
    }
    
    NSLog(@"\n");
}

@end
