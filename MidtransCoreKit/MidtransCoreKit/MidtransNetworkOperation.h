//
//  VTNetworkOperation.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/19/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MTNetworkingDidFinishRequest = @"mt_networking_did_finish_request";
static NSString *const MTNetworkingDidStartRequest = @"mt_networking_did_start_request";

@interface NSObject (Networking)
- (id)networkResponse;
- (NSURLRequest *)networkRequest;
- (NSError *)networkError;
@end

@interface MidtransNetworkOperation : NSOperation
@property (nonatomic, strong) NSString *identifier;
+ (instancetype)operationWithRequest:(NSURLRequest *)request callback:(void(^)(id response, NSError *error))callback;
@end
