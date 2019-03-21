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
#import "MIDTokenizeConfig.h"

@interface MIDCreditCardTokenize : NSObject <MIDTokenizable>

@property (nonatomic) NSString *number;
@property (nonatomic) NSString *expMonth;
@property (nonatomic) NSString *expYear;
@property (nonatomic) NSString *tokenID;
@property (nonatomic) NSString *cvv;

@property (nonatomic) MIDTokenizeConfig *config;

@end
