//
//  VTCPaymentBankTransfer.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTCPaymentDetails.h"

@interface VTCPaymentBankTransfer : NSObject<VTCPaymentDetails>

@property (nonatomic, readonly) NSString* bankName;

- (instancetype)initWithBankName:(NSString *)bankName;

@end
