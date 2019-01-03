//
//  MIDCreditCardPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayable.h"

@interface MIDCreditCardPayment : NSObject<MIDPayable>

@property (nonatomic) NSString *creditCardToken;

@property (nonatomic) NSString *installment;
@property (nonatomic) NSNumber *point;
@property (nonatomic) BOOL saveCard;

@property (nonatomic) NSString *email;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *phoneNumber;

@end
