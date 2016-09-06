//
//  VTNetworkOperation.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransNetworkOperation.h"
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

@interface MidtransNetworkOperation() <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, copy) void (^callback)(id response, NSError *error);
@end

@implementation MidtransNetworkOperation {
    BOOL _isFinished;
    NSMutableData *_responseData;
    BOOL _isAlertShown;
}

+ (instancetype)operationWithRequest:(NSURLRequest *)request callback:(void(^)(id response, NSError *error))callback {
    MidtransNetworkOperation *op = [[MidtransNetworkOperation alloc] init];
    op.callback = callback;
    op.connection = [NSURLConnection connectionWithRequest:request delegate:op];
    return op;
}

- (id)init {
    if (self = [super init]) {
        _isFinished = NO;
        _responseData = [NSMutableData data];
    }
    return self;
}

- (void)main {
    if (self.isCancelled)
        return;
    
    [self.connection start];
}

- (void)cancel {
    [super cancel];
    [self.connection cancel];
    [self finish];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return _isFinished;
}

#pragma mark - Connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.isCancelled)
        return;
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:[_responseData validateUTF8]
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    
    if (responseObject[VT_CORE_STATUS_CODE]) {
        NSInteger code = [responseObject[VT_CORE_STATUS_CODE] integerValue];
        if (code/100 == 2) {
            if (self.callback) self.callback(responseObject, nil);
        } else {
            NSError *error = [NSError errorWithDomain:VT_ERROR_DOMAIN
                                                 code:code
                                             userInfo:@{NSLocalizedDescriptionKey:responseObject[@"status_message"]}];
            if (self.callback) self.callback(nil, error);
        }
    } else {
        if (self.callback) self.callback(responseObject, nil);
    }    
    
    [self finish];
}

- (BOOL)isAccessTokenError:(NSError *)error {
    NSString *errorMessage = error.localizedDescription;
    return [errorMessage containsString:@"access_token"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.isCancelled)
        return;
    
    if (self.callback) {
        self.callback(nil, error);
    }
    
    [self finish];
}

- (nullable NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response {
    return request;
}

- (void)finish {
    _connection = nil;
    [self willChangeValueForKey:@"isFinished"];
    _isFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

@end
