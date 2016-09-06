//
//  VTTransactionDetails.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 An object that contains various details about a transaction.
 The content of this object is adapted from
 http://docs.veritrans.co.id/en/api/methods.html#transaction_details_attr
 */
@interface MidtransTransactionDetails : NSObject

@property (nonatomic, readonly) NSString *orderId;
@property (nonatomic, readonly) NSNumber *grossAmount;

- (instancetype)initWithOrderID:(NSString *)orderID andGrossAmount:(NSNumber *)grossAmount;

- (NSDictionary *)dictionaryValue;

@end
