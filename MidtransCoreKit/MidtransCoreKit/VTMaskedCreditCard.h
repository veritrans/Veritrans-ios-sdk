//
//  VTMaskedCreditCard.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTMaskedCreditCard : NSObject
@property (nonatomic, readonly) NSString *maskedNumber;
@property (nonatomic, readonly) NSString *savedTokenId;

+ (instancetype)maskedCardFromData:(NSDictionary *)data;
@end
