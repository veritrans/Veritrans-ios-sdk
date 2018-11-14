//
//  MIDRequestBuilder.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDNetworkService.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDRequestBuilder : NSObject
+ (NSURLRequest *)buildRequestFrom:(MIDNetworkService *)service;
@end

NS_ASSUME_NONNULL_END
