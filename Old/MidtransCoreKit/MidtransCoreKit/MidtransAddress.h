//
//  VTAddress.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidtransAddress : NSObject

@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSString *city;
@property (nonatomic, readonly) NSString *postalCode;
@property (nonatomic, readonly) NSString *countryCode;

+ (instancetype)addressWithFirstName:(NSString *)firstName
                            lastName:(NSString *)lastName
                               phone:(NSString *)phone
                             address:(NSString *)address
                                city:(NSString *)city
                          postalCode:(NSString *)postalCode
                         countryCode:(NSString *)countryCode;

- (NSDictionary *)dictionaryValue;

@end
