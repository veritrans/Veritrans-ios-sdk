//
//  VTPaymentXLTunai.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTPaymentDetails.h"

@interface MidtransPaymentXLTunai : NSObject <VTPaymentDetails>
- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token;
@end
