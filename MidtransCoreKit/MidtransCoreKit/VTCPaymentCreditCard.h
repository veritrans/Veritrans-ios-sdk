//
//  VTCPaymentCreditCard.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTCPaymentCreditCard : NSObject

@property (nonatomic, readonly) NSString *cardNumber;
@property (nonatomic, readonly) NSString *cardExpiryMonth;
@property (nonatomic, readonly) NSString *cardExpiryYear;
@property (nonatomic, readonly) NSString *cardCvv;

- (instancetype)initWithCardNumber:(NSString *)cardNumber
                   cardExpiryMonth:(NSString *)cardExpiryMonth
                    cardExpiryYear:(NSString *)cardExpiryYear
                           cardCvv:(NSString *)cardCvv;

@end
