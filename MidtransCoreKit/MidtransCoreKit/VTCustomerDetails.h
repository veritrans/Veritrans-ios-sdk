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

@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) VTAddress *shippingAddress;
@property (nonatomic, readonly) VTAddress *billingAddress;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                  shippingAddress:(VTAddress *)shippingAddress
                   billingAddress:(VTAddress *)billingAddress;

- (NSDictionary *)dictionaryValue;

@end
