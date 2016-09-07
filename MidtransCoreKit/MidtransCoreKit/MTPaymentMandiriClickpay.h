//
//  VTPaymentMandiriClickpay.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTPaymentDetails.h"
#import "MTMandiriClickpayHelper.h"

@interface MTPaymentMandiriClickpay : NSObject <MTPaymentDetails>
- (instancetype _Nonnull)initWithCardNumber:(NSString *_Nonnull)cardNumber clickpayToken:(NSString *_Nonnull)clickpayToken token:(MTTransactionTokenResponse *_Nonnull)token;
@end
