//
//  MIDPaymentResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDPaymentResult : NSObject<MIDMappable>

@property (nonatomic) NSString *currency;
@property (nonatomic) NSString *deepLinkURL;
@property (nonatomic) NSString *finishRedirectURL;
@property (nonatomic) NSString *fraudStatus;
@property (nonatomic) NSString *gopayExpiration;
@property (nonatomic) NSString *gopayExpirationRaw;
@property (nonatomic) NSString *grossAmount;
@property (nonatomic) NSString *orderID;
@property (nonatomic) NSString *paymentType;
@property (nonatomic) NSString *qrCodeURL;
@property (nonatomic) NSNumber *statusCode;
@property (nonatomic) NSString *statusMessage;
@property (nonatomic) NSString *transactionID;
@property (nonatomic) NSString *transactionStatus;
@property (nonatomic) NSString *transactionTime;

@end

NS_ASSUME_NONNULL_END
