//
//  MIDCustomerInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 13/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"
#import "MIDModelEnums.h"
#import "MIDAddressInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCustomerInfo : NSObject <MIDMappable>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *phone;
@property (nonatomic) MIDAddressInfo *billingAddress;
@property (nonatomic) MIDAddressInfo *shippingAddress;

@end

NS_ASSUME_NONNULL_END
