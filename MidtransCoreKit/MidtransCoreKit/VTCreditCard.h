//
//  VTCreditCard.h
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTCreditCard : NSObject

@property (nonatomic, readonly) NSString *expiryYear;
@property (nonatomic, readonly) NSString *expiryMonth;
@property (nonatomic, readonly) NSString *number;
@property (nonatomic, readonly) NSString *cvv;

- (instancetype)initWithNumber:(NSString *)number
                   expiryMonth:(NSString *)expiryMonth
                    expiryYear:(NSString *)expiryYear
                           cvv:(NSString *)cvv;

@end
