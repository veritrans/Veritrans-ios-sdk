//
//  MIDCreditCardPayment.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDPayable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCreditCardPayment : NSObject<MIDPayable>

@property (nonatomic) NSString *maskedCardNumber;
@property (nonatomic) NSString *creditCardToken;
@property (nonatomic) BOOL saveCard;

@end

NS_ASSUME_NONNULL_END
