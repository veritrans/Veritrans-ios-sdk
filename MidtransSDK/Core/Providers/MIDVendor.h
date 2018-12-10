//
//  MIDVendor.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDNetworkEnums.h"

@interface MIDVendor : NSObject

@property (readonly) NSString *snapURL;
@property (readonly) NSString *midtransURL;
@property (nonatomic) NSString *merchantURL;
@property (nonatomic) NSString *clientKey;
@property (nonatomic) MIDEnvironment environment;

+ (MIDVendor * _Nonnull)shared;

@end
