//
//  VTPaymentCStore.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTPaymentDetails.h"

@interface VTPaymentCStore : NSObject <VTPaymentDetails>

- (instancetype _Nonnull)initWithStoreName:(NSString *_Nonnull)storeName message:(NSString *_Nonnull)message;

@end
