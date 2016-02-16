//
//  VTNetworking.m
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTNetworking.h"
#import "VTConfig.h"

@implementation NSData (decode)

-(NSData*)validateUTF8 {
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
            NSString *escapedValue = [value isKindOfClass:[NSNumber class]] ? value : [value URLEncodedString];
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

@implementation VTNetworking

+ (id)sharedInstance {
    static VTNetworking *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)postWithEndpoint:(NSString *)endPoint parameters:(NSDictionary *)parameters callback:(void(^)(id response, id error))callback {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] baseUrl], endPoint];
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id responseObject = [NSJSONSerialization JSONObjectWithData:[data validateUTF8]
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        if (callback) {
            callback(responseObject, error);
        }
    }];
    
    [postDataTask resume];
}

- (void)getWithEndpoint:(NSString *)endPoint parameters:(NSDictionary *)parameters callback:(void(^)(id response, id error))callback {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSString *queryString = [parameters queryStringValue];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/%@?%@",[[VTConfig sharedInstance] baseUrl], endPoint, queryString];
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id responseObject = [NSJSONSerialization JSONObjectWithData:[data validateUTF8]
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        if (callback) {
            callback(responseObject, error);
        }
    }];
    
    [postDataTask resume];
}

@end