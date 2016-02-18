//
//  VTUser.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTAddress.h"

@interface VTUser : NSObject

@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) VTAddress *billingAddress;
@property (nonatomic, readonly) VTAddress *shippingAddress;

+ (instancetype)userWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                  shippingAddress:(VTAddress *)shippingAddress
                   billingAddress:(VTAddress *)billingAddress;

- (NSDictionary *)requestData;

@end
