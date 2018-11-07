//
//  MidtransPromoEngine.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/6/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPromo.h"
#import "MidtransObtainedPromo.h"

@interface MidtransPromoEngine : NSObject
+ (void)obtainPromo:(MidtransPromo *)promo withPaymentAmount:(NSNumber *)amount completion:(void(^)(MidtransObtainedPromo *obtainedPromo, NSError *error))completion;
@end
