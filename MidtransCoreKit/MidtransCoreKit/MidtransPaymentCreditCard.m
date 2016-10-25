//
//  MTPaymentCreditCard.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentCreditCard.h"
#import "MidtransHelper.h"
#import "MidtransConfig.h"
#import "MidtransCreditCardConfig.h"

@interface MidtransPaymentCreditCard()
@property (nonatomic) NSString *_Nonnull creditCardToken;
@property (nonatomic) MidtransCustomerDetails *customerDetails;
@end

@implementation MidtransPaymentCreditCard

- (instancetype _Nonnull)initWithCreditCardToken:(NSString *_Nonnull)creditCardToken customerDetails:(MidtransCustomerDetails *_Nonnull)customerDetails {
    if (self = [super init]) {
        self.creditCardToken = creditCardToken;
        self.customerDetails = customerDetails;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"card_token":self.creditCardToken}];
    
    if (self.saveToken) {
        [parameters setObject:@YES forKey:@"save_card"];
    }

    return @{@"payment_type":MIDTRANS_PAYMENT_CREDIT_CARD,
             @"payment_params":parameters,
             @"customer_details":@{@"email":self.customerDetails.email,
                                   @"phone":self.customerDetails.phone}};
}

@end
