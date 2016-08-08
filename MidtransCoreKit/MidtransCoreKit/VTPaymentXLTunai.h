//
//  VTPaymentXLTunai.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTPaymentDetails.h"

@interface VTPaymentXLTunai : NSObject <VTPaymentDetails>
- (instancetype _Nonnull)initWithToken:(TransactionTokenResponse *_Nonnull)token;
@end
