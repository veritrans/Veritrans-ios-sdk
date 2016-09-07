//
//  MTCustomerDetails.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTAddress.h"

@interface MTCustomerDetails : NSObject

@property (nonatomic, strong) NSString *customerIdentifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) MTAddress *shippingAddress;
@property (nonatomic, strong) MTAddress *billingAddress;

@property (nonatomic) NSString *email;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                  shippingAddress:(MTAddress *)shippingAddress
                   billingAddress:(MTAddress *)billingAddress;

- (NSDictionary *)dictionaryValue;

- (NSDictionary *)snapDictionaryValue;

- (BOOL)isValidCustomerData:(NSError **)error;

@end
