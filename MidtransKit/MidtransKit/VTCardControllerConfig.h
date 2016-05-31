//
//  VTCardConfig.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTCardControllerConfig : NSObject
@property (nonatomic) BOOL enableOneClick;
@property (nonatomic) BOOL enable3DSecure;
+ (id)sharedInstance;
@end
