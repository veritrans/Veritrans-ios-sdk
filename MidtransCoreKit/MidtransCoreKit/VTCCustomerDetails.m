//
//  VTCCustomerDetails.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCCustomerDetails.h"

@interface VTCCustomerDetails ()
@property (nonatomic, readwrite) NSString *firstName;
@property (nonatomic, readwrite) NSString *lastName;
@property (nonatomic, readwrite) NSString *email;
@property (nonatomic, readwrite) NSString *phone;
@end

@implementation VTCCustomerDetails

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email phone:(NSString *)phone {
    if (self = [super init]) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.phone = phone;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    // Format MUST BE compatible with
    // http://docs.veritrans.co.id/en/api/methods.html#customer_details_attr
    
    return @{@"first_name": self.firstName,
             @"last_name": self.lastName,
             @"email": self.email,
             @"phone": self.phone};
}

@end
