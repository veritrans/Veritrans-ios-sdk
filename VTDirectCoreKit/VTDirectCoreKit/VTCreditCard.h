//
//  VTCreditCard.h
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTCreditCard : NSObject

@property (nonatomic, readonly) NSNumber *number;
@property (nonatomic, readonly) NSNumber *cvv;
@property (nonatomic, readonly) NSNumber *expiryYear;
@property (nonatomic, readonly) NSNumber *expiryMonth;

//@property (nonatomic, readonly) NSNumber *grossAmount;
//@property (nonatomic, readonly) NSString *bank;
//@property (nonatomic, readonly) BOOL secure;

+ (instancetype)cardWithNumber:(NSNumber *)number expiryMonth:(NSNumber *)expiryMonth expiryYear:(NSNumber *)expiryYear cvv:(NSNumber *)cvv;

@end
