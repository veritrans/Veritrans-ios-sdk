//
//  MIDInstallmentOption.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"

@interface MIDCheckoutInstallment : NSObject<MIDCheckoutable>

@property (nonatomic) BOOL required;
@property (nonatomic) NSDictionary <NSString *, NSArray *> *terms;

/**
 Credit card payment with installment
 
 @param terms Available installment terms
 @param required Force installment when using credit card. Default: false
 */
- (instancetype)initWithTerms:(NSDictionary <NSString *, NSArray *> *)terms required:(BOOL)required;

@end
