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
@property (readonly) NSString *merchantURL;

+ (MIDVendor * _Nonnull)shared;
- (void)applyEnvironment:(MIDEnvironment)env;

@end
