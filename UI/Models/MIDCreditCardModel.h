//
//  MIDCreditCardModel.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 05/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIDCreditCardModel : NSObject

@property (nonatomic, readonly) NSString *expiryYear;
@property (nonatomic, readonly) NSString *expiryMonth;
@property (nonatomic, readonly) NSString *number;
@property (nonatomic, readonly) NSString *cvv;

- (instancetype)initWithNumber:(NSString *)number
                   expiryMonth:(NSString *)expiryMonth
                    expiryYear:(NSString *)expiryYear
                           cvv:(NSString *)cvv;

/**
 * expiryDate format should be 00/00 (month/year)
 */
- (instancetype)initWithNumber:(NSString *)number
                    expiryDate:(NSString *)expiryDate
                           cvv:(NSString *)cvv;

- (NSDictionary *)dictionaryValue;

@end

