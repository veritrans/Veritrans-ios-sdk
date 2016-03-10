//
//  VTPaymentStatusViewModel.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTPaymentStatusViewModel : NSObject

@property (nonatomic, readonly) NSString *totalAmount;
@property (nonatomic, readonly) NSString *orderId;
@property (nonatomic, readonly) NSString *transactionTime;
@property (nonatomic, readonly) NSString *paymentType;

+ (instancetype)viewModelWithData:(NSDictionary *)paymentStatusData;

@end
