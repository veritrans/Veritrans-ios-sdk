//
//  VTCustomerDetails.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCustomerDetails.h"
#import "VTHelper.h"

@interface VTCustomerDetails ()
@end

@implementation VTCustomerDetails

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.customerIdentifier forKey:@"customerIdentifier"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.shippingAddress forKey:@"shippingAddress"];
    [encoder encodeObject:self.billingAddress forKey:@"billingAddress"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.customerIdentifier = [decoder decodeObjectForKey:@"customerIdentifier"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.shippingAddress = [decoder decodeObjectForKey:@"shippingAddress"];
        self.billingAddress = [decoder decodeObjectForKey:@"billingAddress"];
    }
    return self;
}


- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                  shippingAddress:(VTAddress *)shippingAddress
                   billingAddress:(VTAddress *)billingAddress {
    if (self = [super init]) {
        self.customerIdentifier = [[NSUUID UUID] UUIDString];
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.phone = phone;
        self.shippingAddress = shippingAddress;
        self.billingAddress = billingAddress;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    // Format MUST BE compatible with
    // http://docs.veritrans.co.id/en/api/methods.html#customer_details_attr
    
    return @{@"first_name": [VTHelper nullifyIfNil:self.firstName],
             @"last_name": [VTHelper nullifyIfNil:self.lastName],
             @"email": [VTHelper nullifyIfNil:self.email],
             @"phone": [VTHelper nullifyIfNil:self.phone],
             @"shipping_address": [self.shippingAddress dictionaryValue],
             @"billing_address": [self.billingAddress dictionaryValue]};
}

- (NSDictionary *)snapDictionaryValue {
    return @{@"payment_detail":@{@"full_name":[NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName],
                                 @"phone":[VTHelper nullifyIfNil:self.phone],
                                 @"email":[VTHelper nullifyIfNil:self.email]}};
}

@end
