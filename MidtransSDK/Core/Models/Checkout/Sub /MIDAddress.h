//
//  MIDAddress.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"

@interface MIDAddress : NSObject<MIDCheckoutable>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *postalCode;
@property (nonatomic) NSString *countryCode;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                          address:(NSString *)address
                             city:(NSString *)city
                       postalCode:(NSString *)postalCode
                      countryCode:(NSString *)countryCode;

@end
