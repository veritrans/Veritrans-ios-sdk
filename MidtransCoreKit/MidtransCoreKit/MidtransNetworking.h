//
//  VTNetworking.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidtransNetworking : NSObject

+ (MidtransNetworking *)shared;

- (void)deleteFromURL:(NSString *)URL
               header:(NSDictionary *)header
           parameters:(NSDictionary *)parameters
             callback:(void(^)(id response, NSError *error))callback;

- (void)postToURL:(NSString *)URL
       parameters:(id)parameters
         callback:(void(^)(id response, NSError *error))callback;

- (void)getFromURL:(NSString *)URL
        parameters:(NSDictionary *)parameters
          callback:(void(^)(id response, NSError *error))callback;

- (void)postToURL:(NSString *)URL
           header:(NSDictionary *)header
       parameters:(id)parameters
         callback:(void (^)(id response, NSError *errpr))callback;

- (void)getFromURL:(NSString *)URL
            header:(NSDictionary *)header
        parameters:(NSDictionary *)parameters
          callback:(void(^)(id response, NSError *error))callback;

@end
