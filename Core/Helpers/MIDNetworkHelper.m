//
//  MIDNetworkHelper.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDNetworkHelper.h"

@implementation NSData (decode)

- (NSData*)MIDValidateUTF8 {
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

- (NSString *)MIDURLEncodedString {
    return [self stringByRemovingPercentEncoding];
}

@end

@implementation NSDictionary (core_parse)

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
                escapedValue = [value MIDURLEncodedString];
            
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
            NSString *escapedValue = [value isKindOfClass:[NSNumber class]] ? value : [value MIDURLEncodedString];
            [result addObject:[NSString stringWithFormat:@"%@[]=%@", key, escapedValue]];
        }
    }
    
    return result;
}

@end

@implementation NSError (builder)

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message reasons:(id)reason {
    NSMutableDictionary *info = [NSMutableDictionary new];
    if (message) {
        [info setObject:message forKey:NSLocalizedDescriptionKey];
    }
    
    if (reason) {
        [info setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
    }
    
    NSError *error = [NSError errorWithDomain:@"error.midtrans.com" code:code userInfo:info];
    return error;
}

@end
