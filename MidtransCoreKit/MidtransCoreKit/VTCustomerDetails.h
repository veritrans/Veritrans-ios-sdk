//
//  VTCustomerDetails.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTAddress.h"

@interface VTCustomerDetails : NSObject

@property (nonatomic, strong) NSString *customerIdentifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) VTAddress *shippingAddress;
@property (nonatomic, strong) VTAddress *billingAddress;

@property (nonatomic) NSString *email;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                  shippingAddress:(VTAddress *)shippingAddress
                   billingAddress:(VTAddress *)billingAddress;

- (NSDictionary *)dictionaryValue;

- (NSDictionary *)snapDictionaryValue;

- (BOOL)isValidCustomerData:(NSError **)error;

@end
