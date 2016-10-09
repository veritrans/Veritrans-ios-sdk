//
//  VTPaymentTelkomselCash.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPaymentDetails.h"

@interface MidtransPaymentTelkomselCash : NSObject <MidtransPaymentDetails>
- (instancetype _Nonnull)initWithMSISDN:(NSString *_Nonnull)msisdn;
@end
