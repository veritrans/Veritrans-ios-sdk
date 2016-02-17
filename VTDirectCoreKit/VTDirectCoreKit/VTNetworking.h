//
//  VTNetworking.h
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTNetworking : NSObject

+ (id)sharedInstance;

- (void)post:(NSString *)endPoint parameters:(NSDictionary *)parameters callback:(void(^)(id response, NSError *error))callback;
- (void)get:(NSString *)endPoint parameters:(NSDictionary *)parameters callback:(void(^)(id response, NSError *error))callback;

@end
