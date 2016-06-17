//
//  VTTrackingManager.h
//  MidtransCoreKit
//
//  Created by atta on 6/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface VTTrackingManager : NSObject
+ (VTTrackingManager *)sharedInstance;
- (void)trackAppGenerateToken:(NSString *)token
               secureProtocol:(BOOL)secure
           withPaymentFeature:(NSInteger)paymentFeature
                paymentMethod:(NSString *)paymentMethod
                        value:(NSNumber *)value;
@end
