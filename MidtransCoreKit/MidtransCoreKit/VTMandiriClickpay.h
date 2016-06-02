//
//  VTMandiriClickpay.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/26/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const APPLIClickpay;

@interface VTMandiriClickpay : NSObject

@property (nonatomic) NSString *debitNumber;
@property (nonatomic) NSString *token;
@property (nonatomic, readonly) NSString *input1;
@property (nonatomic, readonly) NSString *input2;
@property (nonatomic, readonly) NSString *input3;

+ (instancetype)dataWithTransactionAmount:(NSNumber *)transactionAmount;

- (NSDictionary *)requestData;

@end
