//
//  MIDConfig.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 09/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIDConfig : NSObject
@property (nonatomic) double requestTimeout;
+ (MIDConfig * _Nonnull)shared;
@end
