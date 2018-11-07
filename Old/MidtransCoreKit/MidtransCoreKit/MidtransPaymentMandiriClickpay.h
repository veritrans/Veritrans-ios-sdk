//
//  VTPaymentMandiriClickpay.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPaymentDetails.h"
#import "MidtransMandiriClickpayHelper.h"

@interface MidtransPaymentMandiriClickpay : NSObject <MidtransPaymentDetails>
- (instancetype _Nonnull)initWithCardToken:(NSString *_Nonnull)cardToken clickpayToken:(NSString *_Nonnull)clickpayToken;
@end
