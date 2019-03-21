//
//  MIDTokenizeResponse.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 02/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface MIDTokenizeResponse : NSObject <MIDMappable>

@property (nonatomic) NSString *bank;
@property (nonatomic) NSString *maskedCard;
@property (nonatomic) NSString *secureURL;
@property (nonatomic) NSInteger statusCode;
@property (nonatomic) NSString *statusMessage;
@property (nonatomic) NSString *tokenID;

@end
