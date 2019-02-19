//
//  MIDPaymentResult.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDModelHelper.h"
#import "MIDMappable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDPaymentResult : NSObject<MIDMappable>

@property (nonatomic) NSString *currency;
@property (nonatomic) NSString *finishRedirectURL;
@property (nonatomic) NSNumber *grossAmount;
@property (nonatomic) NSString *orderID;
@property (nonatomic) MIDPaymentMethod paymentMethod;
@property (nonatomic) NSInteger statusCode;
@property (nonatomic) NSString *statusMessage;
@property (nonatomic) NSString *transactionID;
@property (nonatomic) NSString *transactionStatus;
@property (nonatomic) NSDate *transactionTime;

/**
 Expire date for pending transaction type
 */
@property (nonatomic) NSString *expiration;

/**
 Fraud status for credit card payment
 */
@property (nonatomic) NSString *fraudStatus;

/**
 Download URL for payment guide.
 */
@property (nonatomic) NSString *pdfURL;

@end

NS_ASSUME_NONNULL_END
