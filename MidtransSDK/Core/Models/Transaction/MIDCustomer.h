//
//  MIDCustomer.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"
#import "MIDAddress.h"

@interface MIDCustomer : NSObject<MIDMappable>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *phone;
@property (nonatomic) MIDAddress *billingAddress;
@property (nonatomic) MIDAddress *shippingAddress;

@end
