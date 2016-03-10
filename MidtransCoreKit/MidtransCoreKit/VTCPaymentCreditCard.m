//
//  VTCPaymentCreditCard.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCPaymentCreditCard.h"

@interface VTCPaymentCreditCard()

@property (nonatomic, readwrite) NSString *number;
@property (nonatomic, readwrite) NSString *expiryMonth;
@property (nonatomic, readwrite) NSString *expiryYear;
@property (nonatomic, readwrite) NSString *cvv;

@end

@implementation VTCPaymentCreditCard

- (instancetype)initWithNumber:(NSString *)number expiryMonth:(NSString *)expiryMonth expiryYear:(NSString *)expiryYear cvv:(NSString *)cvv {
    if (self = [super init]) {
        self.number = number;
        self.expiryMonth = expiryMonth;
        self.expiryYear = expiryYear;
        self.cvv = cvv;
    }
    
    return self;
}

@end
