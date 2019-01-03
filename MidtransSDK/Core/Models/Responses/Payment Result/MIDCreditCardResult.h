//
//  MIDCreditCardResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCreditCardResult : MIDPaymentResult

@property (nonatomic) NSString *approvalCode;
@property (nonatomic) NSString *bank;
@property (nonatomic) NSString *cardType;
@property (nonatomic) NSString *cardToken;
@property (nonatomic) NSString *cardTokenExpireDate;

@end

NS_ASSUME_NONNULL_END
