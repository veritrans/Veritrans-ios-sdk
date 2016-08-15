//
//  VTNetworking.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTNetworking.h"
#import "VTConfig.h"
#import "VTNetworkOperation.h"
#import "VTConstant.h"

@implementation NSData (decode)

- (NSData*)validateUTF8 {
    NSString *strUtf8 = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    NSString *strAscii = [[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding];
    if (strUtf8) {
        return self;
    }
    
    NSData *utf8Data = [strAscii dataUsingEncoding:NSUTF8StringEncoding];
    
    return utf8Data;
}

@end

@implementation NSString (encode)

- (NSString *)URLEncodedString {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSDictionary (parse)

- (NSString *)queryStringValue {
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [self keyEnumerator]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            [pairs addObjectsFromArray:[self pairsOfArray:value key:key]];
        } else {
            NSString *escapedValue;
            
            if ([value isKindOfClass:[NSNumber class]])
                escapedValue = value;
            else if ([value isKindOfClass:[NSNull class]])
                escapedValue = @"";
            else
                escapedValue = [value URLEncodedString];
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escapedValue]];
        }
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSArray *)pairsOfArray:(NSArray *)values key:(NSString *)key {
    NSMutableArray *result = [NSMutableArray new];
    
    for (id value in values) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *pairs = [self pairsOfArray:value key:key];
            [result addObjectsFromArray:pairs];
        } else {
            NSString *escapedValue = [value isKindOfClass:[NSNumber class]] ? value : [value URLEncodedString];
            [result addObject:[NSString stringWithFormat:@"%@[]=%@", key, escapedValue]];
        }
    }
    
    return result;
}

@end


@interface VTNetworking ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation VTNetworking

+ (id)sharedInstance {
    static VTNetworking *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    if (self = [super init]) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)deleteFromURL:(NSString *)URL
               header:(NSDictionary *)header
           parameters:(NSDictionary *)parameters
             callback:(void(^)(id response, NSError *error))callback
{
    NSString *params = [parameters queryStringValue];
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", URL, params]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    for (NSString *key in [header allKeys]) {
        [request addValue:header[key] forHTTPHeaderField:key];
    }
    
    VTNetworkOperation *op = [VTNetworkOperation operationWithRequest:request
                                                             callback:callback];
    [_operationQueue addOperation:op];
}

- (void)postToURL:(NSString *)URL header:(NSDictionary *)header parameters:(id)parameters callback:(void (^)(id response, NSError *error))callback {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:URL]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60];
    
    if (parameters) {
        NSData *body = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        [request setHTTPBody:body];
    }
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    for (NSString *key in [header allKeys]) {
        [request addValue:header[key] forHTTPHeaderField:key];
    }
    
    VTNetworkOperation *op = [VTNetworkOperation operationWithRequest:request
                                                             callback:callback];
    [_operationQueue addOperation:op];
}

- (void)postToURL:(NSString *)URL
       parameters:(NSDictionary *)parameters
         callback:(void(^)(id response, NSError *error))callback
{
    [self postToURL:URL header:nil parameters:parameters callback:callback];
}

- (void)getFromURL:(NSString *)URL
            header:(NSDictionary *)header
        parameters:(NSDictionary *)parameters
          callback:(void(^)(id response, NSError *error))callback
{
    NSString *params = [parameters queryStringValue];
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", URL, params]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60];
    for (NSString *key in [header allKeys]) {
        [request addValue:header[key] forHTTPHeaderField:key];
    }
    
    VTNetworkOperation *op = [VTNetworkOperation operationWithRequest:request
                                                             callback:callback];
    [_operationQueue addOperation:op];
}

- (void)getFromURL:(NSString *)URL
        parameters:(NSDictionary *)parameters
          callback:(void(^)(id response, NSError *error))callback
{
    [self getFromURL:URL header:nil parameters:parameters callback:callback];
}

+ (void)handleError:(NSError *)error callback:(void(^)(id response, NSError *error))callback {
    if (callback) {
        callback(nil, error);
    }
}

+ (void)handleResponse:(id)response callback:(void(^)(id response, NSError *error))callback {
    NSError *error;
    id _response;
    
    NSInteger code = [response[VT_CORE_STATUS_CODE] integerValue];
    NSString *message = response[@"status_message"];
    
    if (code == 200) {
        _response = response;
    } else {
        error = [[NSError alloc] initWithDomain:VT_ERROR_DOMAIN code:code userInfo:@{NSLocalizedDescriptionKey:message}];
    }
    
    if (callback) {
        callback(_response, error);
    }
}

@end