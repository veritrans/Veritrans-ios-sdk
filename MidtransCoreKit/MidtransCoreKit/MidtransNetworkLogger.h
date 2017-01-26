//
//  MidtransNetworkLogger.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 1/26/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidtransNetworkLogger : NSObject
+ (MidtransNetworkLogger *)shared;
- (void)startLogging;
- (void)stopLogging;
@end
