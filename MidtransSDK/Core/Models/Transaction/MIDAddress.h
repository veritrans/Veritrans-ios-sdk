//
//  MIDAddress.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface MIDAddress : NSObject<MIDMappable>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSNumber *lastName;
@property (nonatomic) NSNumber *email;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *postalCode;
@property (nonatomic) NSString *countryCode;

@end
