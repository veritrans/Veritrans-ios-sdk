//
//  VTMandiriClickpayHelper.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidtransMandiriClickpayHelper : NSObject

+ (NSString *_Nonnull)generateInput1FromCardNumber:(NSString *_Nonnull)cardNumber;
+ (NSString *_Nonnull)generateInput2FromGrossAmount:(NSNumber *_Nonnull)grossAmount;
+ (NSString *_Nonnull)generateInput3;

@end
