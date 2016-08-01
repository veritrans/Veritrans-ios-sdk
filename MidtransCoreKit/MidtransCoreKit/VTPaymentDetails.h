//
//  VTCPaymentDetails.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTConstant.h"

/**
 Protocol that needs to be implemented for each payment type.
 */
@protocol VTPaymentDetails <NSObject>

/**
 The payment type identifier. Must be one of "credit_card", "bank_transfer", "mandiri_clickpay", "cimb_clicks", "bca_klikpay", "bri_epay", "telkomsel_cash", "xl_tunai", "echannel", "mandiri_ecash", "bbm_money", "cstore" or "indosat_dompetku".
 */
- (NSString *_Nonnull)paymentType;

/**
 The `NSDictionary` representaion of the payment type. Please consult to http://docs.veritrans.co.id/en/api/methods.html#charge-transaction to know what key-value pair that needs to be included.
 */
- (NSDictionary *_Nullable)dictionaryValue;

- (NSString *_Nonnull)chargeURL;

@end
