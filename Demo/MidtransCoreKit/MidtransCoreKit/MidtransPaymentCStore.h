//
//  VTPaymentCStore.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPaymentDetails.h"

@interface MidtransPaymentCStore : NSObject <MidtransPaymentDetails>

- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token;
@end
