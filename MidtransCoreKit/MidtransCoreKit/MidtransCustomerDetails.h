//
//  MidtransCustomerDetails.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransAddress.h"

@interface MidtransCustomerDetails : NSObject

@property (nonatomic, strong) NSString *customerIdentifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) MidtransAddress *shippingAddress;
@property (nonatomic, strong) MidtransAddress *billingAddress;

@property (nonatomic) NSString *email;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                  shippingAddress:(MidtransAddress *)shippingAddress
                   billingAddress:(MidtransAddress *)billingAddress;

- (NSDictionary *)dictionaryValue;

- (NSDictionary *)snapDictionaryValue;

- (BOOL)isValidCustomerData:(NSError **)error;

@end
