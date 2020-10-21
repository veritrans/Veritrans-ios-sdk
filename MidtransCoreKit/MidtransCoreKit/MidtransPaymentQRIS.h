//
//  MidtransPaymentQRIS.h
//  MidtransCoreKit
//
//  Created by Vanbungkring on 11/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransPaymentDetails.h"
@interface MidtransPaymentQRIS : NSObject<MidtransPaymentDetails>
- (instancetype _Nonnull)initWithAcquirer:(NSString *_Nonnull)acquirer;
@end
