//
//  MIdtransPaymentGCI.h
//  MidtransCoreKit
//
//  Created by Vanbungkring on 12/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPaymentDetails.h"
@interface MIdtransPaymentGCI : NSObject<MidtransPaymentDetails>
- (instancetype _Nonnull)initWithCardNumber:(NSString *_Nonnull)cardNumber password:(NSString *_Nonnull)password;
@end
