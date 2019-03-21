//
//  MIDRequest.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDNetworkEnums.h"

@interface MIDNetworkService : NSObject

@property (readonly, nonnull) NSString *baseURL;
@property (readonly, nonnull) NSString *path;
@property (readonly) MIDHTTPMethod method;
@property (readonly) NSDictionary *parameters;

- (instancetype)initWithBaseURL:(NSString *)baseURL
                           path:(NSString *)path
                         method:(MIDHTTPMethod)method
                     parameters:(NSDictionary *)parameters;
@end
