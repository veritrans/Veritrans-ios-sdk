//
//  VTCPaymentDetails.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransConstant.h"
#import "MidtransTransactionTokenResponse.h"

/**
 Protocol that needs to be implemented for each payment type.
 */
@protocol MidtransPaymentDetails <NSObject>

/**
 The `NSDictionary` representaion of the payment type. Please consult to http://docs.veritrans.co.id/en/api/methods.html#charge-transaction to know what key-value pair that needs to be included.
 */
- (NSDictionary *_Nullable)dictionaryValue;

@end
