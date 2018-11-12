//
//  MIDRequestBuilder.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDRequestBuilder.h"
#import "MIDNetworkHelper.h"
#import "MIDVendor.h"
#import "MIDConfig.h"
#import "MIDNetworkConstants.h"

@implementation MIDRequestBuilder

+ (NSURLRequest *)buildRequestFrom:(MIDNetworkService *)service {
    MIDHTTPMethod method = service.method;
    NSDictionary *params = service.parameters;
    NSDictionary *header = [self buildHeader:method];
    NSString *requestURL = [self combineBaseURL:service.baseURL andPath:service.path];
    NSURL *url = [self buildURL:requestURL method:method parameters:params];
    return [self buildRequest:method header:header requestURL:url parameters:params];
}

+ (NSURLRequest *)buildRequest:(MIDHTTPMethod)method header:(NSDictionary *)header requestURL:(NSURL *)requestURL parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:[MIDConfig shared].requestTimeout];
    [request setHTTPMethod:[self buildMethod:method]];
    
    for (NSString *key in [header allKeys]) {
        [request addValue:header[key] forHTTPHeaderField:key];
    }
    
    if (parameters) {
        NSData *body = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        [request setHTTPBody:body];
    }
    
    return request;
}

+ (NSString *)combineBaseURL:(NSString *)baseURL andPath:(NSString *)path {
    if ([baseURL hasSuffix:@"/"]) {
        baseURL = [baseURL substringToIndex:[baseURL length]-1];
    }
    if ([path hasSuffix:@"/"]) {
        path = [path substringToIndex:[path length]-1];
    }
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    return [NSString stringWithFormat:@"%@/%@", baseURL, path];
}

+ (NSURL *)buildURL:(NSString *)requestURL method:(MIDHTTPMethod)method parameters:(NSDictionary *)parameters {
    NSURL *url = [NSURL URLWithString:requestURL];
    if (method == MIDNetworkMethodGET && parameters) {
        NSString *params = [parameters queryStringValue];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", requestURL, params]];
    }
    return url;
}

+ (NSString *)buildMethod:(MIDHTTPMethod)method {
    switch (method) {
        case MIDNetworkMethodGET:
            return @"GET";
        case MIDNetworkMethodPOST:
            return @"POST";
        default:
            return @"DELETE";
    }
}

+ (NSMutableDictionary *)buildHeader:(MIDHTTPMethod)method {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setDictionary:@{@"X-Source": @"mobile-ios",
                            @"X-Mobile-Platform": @"ios",
                            @"X-Source-Version": SDK_VERSION
                            }];
    if (method != MIDNetworkMethodGET) {
        [result addEntriesFromDictionary:@{@"Content-Type": @"application/json"}];
    }
    return result;
}

@end
