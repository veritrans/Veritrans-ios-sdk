//
//  VTPaymentMandiriClickpay.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTPaymentDetails.h"
#import "MidtransMandiriClickpayHelper.h"

@interface MidtransPaymentMandiriClickpay : NSObject <VTPaymentDetails>
- (instancetype _Nonnull)initWithCardNumber:(NSString *_Nonnull)cardNumber clickpayToken:(NSString *_Nonnull)clickpayToken token:(MidtransTransactionTokenResponse *_Nonnull)token;
@end
