//
//  VTAddress.h
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTAddress : NSObject

@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSString *city;
@property (nonatomic, readonly) NSString *zipCode;
@property (nonatomic, readonly) NSString *country;

@end
