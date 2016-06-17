//
//  VTPaymentMandiriECash.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTPaymentDetails.h"

@interface VTPaymentMandiriECash : NSObject<VTPaymentDetails>
- (instancetype _Nonnull)initWithDescription:(NSString * _Nonnull)description;
@end
