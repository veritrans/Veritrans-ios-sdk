//
//  MIDPromoInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface MIDPromo : NSObject <MIDMappable>

@property (nonatomic) NSArray *bins;
@property (nonatomic) NSArray *paymentTypes;
@property (nonatomic) NSString *discountType;
@property (nonatomic) NSNumber *promoID;
@property (nonatomic) NSNumber *discountedGrossAmount;
@property (nonatomic) NSNumber *calculatedDiscountAmount;
@property (nonatomic) NSString *name;

@end


@interface MIDPromoInfo : NSObject <MIDMappable>

@property (nonatomic) NSArray <MIDPromo *>*promos;

@end
