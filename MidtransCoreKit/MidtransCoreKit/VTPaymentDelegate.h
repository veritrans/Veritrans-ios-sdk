//
//  VTPaymentDelegate.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VTPaymentDelegate
- (void)paymentSuccessfullyCompleted;
- (void)paymentFailed;
@end
