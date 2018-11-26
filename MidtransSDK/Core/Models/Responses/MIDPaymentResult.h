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
@property (nonatomic) NSString *finishRedirectURL;
@property (nonatomic) NSString *fraudStatus;
@property (nonatomic) NSString *grossAmount;
@property (nonatomic) NSString *orderID;
@property (nonatomic) NSString *paymentType;
@property (nonatomic) NSNumber *statusCode;
@property (nonatomic) NSString *statusMessage;
@property (nonatomic) NSString *transactionID;
@property (nonatomic) NSString *transactionStatus;
@property (nonatomic) NSString *transactionTime;

/**
 Virtual Account information for BCA.
 */
@property (nonatomic) NSString *bcaExpiration;
@property (nonatomic) NSString *bcaVANumber;

/**
 Virtual Account information for BNI.
 */
@property (nonatomic) NSString *bniExpiration;
@property (nonatomic) NSString *bniVANumber;

/**
 Virtual Account information for Permata.
 */
@property (nonatomic) NSString *permataExpiration;
@property (nonatomic) NSString *permataVANumber;

/**
 Virtual Account information for EChannel.
 */
@property (nonatomic) NSString *billpaymentExpiration;
@property (nonatomic) NSString *billKey;
@property (nonatomic) NSString *billerCode;

/**
 Download URL for Virtual Account guide.
 */
@property (nonatomic) NSString *pdfURL;

/**
 GoPay payment information.
 */
@property (nonatomic) NSString *qrCodeURL;
@property (nonatomic) NSString *gopayExpiration;
@property (nonatomic) NSString *gopayExpirationRaw;
@property (nonatomic) NSString *deepLinkURL;

@end

NS_ASSUME_NONNULL_END
