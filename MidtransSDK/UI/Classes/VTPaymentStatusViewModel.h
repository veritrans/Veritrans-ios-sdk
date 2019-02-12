//
//  VTPaymentStatusViewModel.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MidtransCoreKit/MidtransTransactionResult.h>

@interface VTPaymentStatusViewModel : NSObject

@property (nonatomic) NSString *totalAmount;
@property (nonatomic) NSString *orderId;
@property (nonatomic) NSString *transactionTime;
@property (nonatomic) NSDictionary *additionalData;
@property (nonatomic) NSString *paymentType;
@property (nonatomic, readonly) MidtransTransactionResult *transactionResult;

- (instancetype)initWithTransactionResult:(MidtransTransactionResult *)transactionResult;

@end
