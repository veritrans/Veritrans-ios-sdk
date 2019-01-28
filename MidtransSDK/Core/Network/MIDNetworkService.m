//
//  MIDRequest.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDNetworkService.h"
#import "MIDNetworkConstants.h"
#import "MIDNetworkHelper.h"
#import "MIDVendor.h"
#import "MIDConfig.h"

@interface MIDNetworkService()
@property (readwrite) NSString *baseURL;
@property (readwrite) NSString *path;
@property (readwrite) MIDHTTPMethod method;
@property (readwrite) NSDictionary *parameters;
@end

@implementation MIDNetworkService

- (instancetype)initWithBaseURL:(NSString * _Nonnull)baseURL
                           path:(NSString *_Nullable)path
                         method:(MIDHTTPMethod)method
                     parameters:(NSDictionary *_Nullable)parameters {
    if (self = [super init]) {
        self.baseURL = baseURL;
        self.path = path;
        self.method = method;
        self.parameters = parameters;
    }
    return self;
}

@end
