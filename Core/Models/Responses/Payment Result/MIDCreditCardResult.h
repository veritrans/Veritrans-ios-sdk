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
@property (nonatomic) NSString *pointBalanceAmount;
@property (nonatomic) NSString *pointRedeemAmount;
@property (nonatomic) NSString *pointRedeemQuantity;

@property (nonatomic) NSString *RBAURL;

@end

NS_ASSUME_NONNULL_END
