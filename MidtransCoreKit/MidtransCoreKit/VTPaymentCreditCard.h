//
//  VTPaymentCreditCard.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTCPaymentDetails.h"

@interface VTPaymentCreditCard : NSObject<VTCPaymentDetails>
@property (nonatomic, readonly) NSString *tokenId;

@property (nonatomic) NSString *bank;
@property (nonatomic) NSNumber *installment;
@property (nonatomic) NSArray *bins;
@property (nonatomic) NSString *type;
@property (nonatomic) BOOL saveTokenId;

+ (instancetype)paymentForTokenId:(NSString *)tokenId;
@end
