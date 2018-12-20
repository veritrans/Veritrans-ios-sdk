//
//  MIDCreditCardTokenize.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 11/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDTokenizable.h"
#import "MIDModelEnums.h"

@interface MIDCreditCardTokenize : NSObject <MIDTokenizable>

@property (nonatomic) NSString *cardNumber;
@property (nonatomic) NSString *cardCVV;
@property (nonatomic) NSString *cardExpMonth;
@property (nonatomic) NSString *cardExpYear;
@property (nonatomic) MIDAcquiringBank bank;
@property (nonatomic) BOOL secure;
@property (nonatomic) NSString *grossAmount;
@property (nonatomic) NSString *installmentTerm;
@property (nonatomic) NSString *tokenID;
@property (nonatomic) MIDCreditCardTransactionType type;
@property (nonatomic) BOOL point;



@end
