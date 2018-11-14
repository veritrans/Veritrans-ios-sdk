//
//  MIDNetwork.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MIDNetworkService.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDNetwork : NSObject

+ (MIDNetwork *)shared;
- (void)request:(MIDNetworkService *)service completion:(void(^_Nullable)(id _Nullable response, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
