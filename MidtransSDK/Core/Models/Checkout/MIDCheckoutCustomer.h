//
//  MIDCustomer.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutOption.h"
#import "MIDAddress.h"

@interface MIDCheckoutCustomer : NSObject<MIDCheckoutOption>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *phone;
@property (nonatomic) MIDAddress *billingAddress;
@property (nonatomic) MIDAddress *shippingAddress;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                   billingAddress:(MIDAddress *)billingAddress
                  shippingAddress:(MIDAddress *)shippingAddress;

@end
