//
//  VTCTransaction.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCTransactionRequest.h"

@interface VTCTransactionRequest()

@property (nonatomic, readwrite) NSString* orderId;
@property (nonatomic, readwrite) Float32 amount;
@property (nonatomic, readwrite) enum VTCTransactionRequestPaymentMethod paymentMethod;
@property (nonatomic, readwrite) NSMutableDictionary<NSString*, NSString*> *billInfo;
@property (nonatomic, readwrite) NSMutableArray<VTItem *> *items;

@end

@implementation VTCTransactionRequest

- (instancetype)init {
    if (self = [super init]) {
        // Default values initilization
        self.isSecureCard = FALSE;
        self.cardClickType = VTCTransactionRequestCardClickTypeNone;
        self.billInfo = [[NSMutableDictionary alloc] init];
        self.items = [[NSMutableArray alloc] init];
        self.billingAddress = [[VTAddress alloc] init];
        self.shippingAddress = [[VTAddress alloc] init];
        self.customerDetails = [[VTCustomerDetails alloc] init];
        self.useUi = FALSE;
    }
    return self;
}

- (instancetype)initWithOrderId:(NSString *)orderId amount:(Float32)amount {
    if (self = [self init]) {
        self.orderId = orderId;
        self.amount = amount;
        self.paymentMethod = VTCTransactionPaymentMethodUnspecified;
    }
    return self;
}

- (instancetype)initWithOrderId:(NSString *)orderId amount:(Float32)amount paymentMethod:(enum VTCTransactionRequestPaymentMethod)paymentMethod {
    if (self = [self init]) {
        self.orderId = orderId;
        self.amount = amount;
        self.paymentMethod = paymentMethod;
    }
    return self;
}

@end
