//
//  VTNetworkOperation.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransNetworkOperation.h"
#import "MidtransConstant.h"

NSString *const kMTNetworkOperationResponse = @"mt_response";
NSString *const kMTNetworkOperationRequest = @"mt_request";
NSString *const kMTNetworkOperationError = @"mt_error";

@implementation NSObject (Networking)

- (id)networkResponse {
    return [self valueForKey:kMTNetworkOperationResponse];
}
- (NSURLRequest *)networkRequest {
    return [self valueForKey:kMTNetworkOperationRequest];
}
- (NSError *)networkError {
    return [self valueForKey:kMTNetworkOperationError];
}

@end

@implementation NSData (decode)

- (NSData*)SNPvalidateUTF8 {
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

- (NSString *)SNPURLEncodedString {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

@interface MidtransNetworkOperation() <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) NSURLRequest *request;
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
    op.request = request;
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
    
    NSMutableDictionary *object = [NSMutableDictionary new];
    if (self.request)
        [object setObject:self.request forKey:kMTNetworkOperationRequest];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTNetworkingDidStartRequest object:object];
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
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:[_responseData SNPvalidateUTF8]
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    
    NSMutableDictionary *object = [NSMutableDictionary new];
    NSURLRequest *request = connection.currentRequest;
    if (request)
        [object setObject:request forKey:kMTNetworkOperationRequest];
    if (_responseData)
        [object setObject:[_responseData SNPvalidateUTF8] forKey:kMTNetworkOperationResponse];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTNetworkingDidFinishRequest object:object];
    
    if (responseObject[MIDTRANS_CORE_STATUS_CODE]) {
        NSInteger code = [responseObject[MIDTRANS_CORE_STATUS_CODE] integerValue];
        if (code/100 == 2) {
            if (self.callback) self.callback(responseObject, nil);
        }
        else if (code == 400) {
            id statusMessage = responseObject[@"status_message"];
            id validationMessage = responseObject[@"validation_messages"];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            if (statusMessage) {
                userInfo[NSLocalizedDescriptionKey] = statusMessage;
            }
            
            if (validationMessage) {
                userInfo[NSLocalizedFailureReasonErrorKey] = validationMessage;
            }
            
            NSError *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN
                                                 code:code
                                             userInfo:userInfo];
            if (self.callback) self.callback(nil, error);
        }
        else {
            id statusMessage = responseObject[@"status_message"];
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            if (statusMessage) {
                userInfo[NSLocalizedDescriptionKey] = statusMessage;
            }
            
            NSError *error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN
                                                 code:code
                                             userInfo:userInfo];
            if (self.callback) self.callback(nil, error);
        }
    }
    else {
        if (self.callback) self.callback(responseObject, nil);
    }
    
    [self finish];
}

- (BOOL)isAccessTokenError:(NSError *)error {
    NSMutableDictionary *object = [NSMutableDictionary new];
    if (error)
        [object setObject:error forKey:kMTNetworkOperationError];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTNetworkingDidFinishRequest object:object];
    
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
