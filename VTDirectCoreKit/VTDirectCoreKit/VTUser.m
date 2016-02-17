//
//  VTUser.m
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTUser.h"

@interface VTUser ()

@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *email;
@property (nonatomic, readwrite) NSNumber *phone;
@property (nonatomic, readwrite) VTAddress *address;
@property (nonatomic, readwrite) VTAddress *billingAddress;

@end

@implementation VTUser

+ (instancetype)userWithName:(NSString *)name email:(NSString *)email phone:(NSNumber *)phone address:(VTAddress *)address billingAddress:(VTAddress *)billingAddress {
    VTUser *user = [[VTUser alloc] init];
    user.name = name;
    user.email = email;
    user.phone = phone;
    user.address = address;
    user.billingAddress = billingAddress;
    return user;
}

@end
