//
//  VTUser.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTUser.h"
#import "VTHelper.h"

@interface VTUser ()

@property (nonatomic, readwrite) NSString *firstName;
@property (nonatomic, readwrite) NSString *lastName;
@property (nonatomic, readwrite) NSString *email;
@property (nonatomic, readwrite) NSString *phone;
@property (nonatomic, readwrite) VTAddress *billingAddress;
@property (nonatomic, readwrite) VTAddress *shippingAddress;

@end

@implementation VTUser

+ (instancetype)userWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                  shippingAddress:(VTAddress *)shippingAddress
                   billingAddress:(VTAddress *)billingAddress
{
    VTUser *user = [[VTUser alloc] init];
    user.firstName = firstName;
    user.lastName = lastName;
    user.email = email;
    user.phone = phone;
    user.billingAddress = billingAddress;
    user.shippingAddress = shippingAddress;
    return user;
}

- (NSDictionary *)customerDetails {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"first_name":[VTHelper nullifyIfNil:_firstName],
                                     @"last_name":[VTHelper nullifyIfNil:_lastName],
                                     @"email":[VTHelper nullifyIfNil:_email],
                                     @"phone":[VTHelper nullifyIfNil:_phone]}];
    if (_billingAddress) {
        [result setValue:_billingAddress.requestData forKey:@"billing_address"];
    }
    if (_shippingAddress) {
        [result setValue:_shippingAddress.requestData forKey:@"shipping_address"];
    }
    
    return result;
}

@end
