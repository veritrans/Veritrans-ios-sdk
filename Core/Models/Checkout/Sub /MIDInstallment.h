//
//  MIDInstallmentOption.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"
#import "MIDInstallmentTerm.h"

@interface MIDInstallment : NSObject<MIDCheckoutable>

@property (nonatomic) BOOL required;
@property (nonatomic) NSArray <MIDInstallmentTerm *> *terms;

/**
 Credit card payment with installment
 
 @param terms Available installment terms
 @param required Force installment when using credit card. Default: false
 */
- (instancetype _Nonnull)initWithTerms:(NSArray <MIDInstallmentTerm *> *)terms required:(BOOL)required;

@end
