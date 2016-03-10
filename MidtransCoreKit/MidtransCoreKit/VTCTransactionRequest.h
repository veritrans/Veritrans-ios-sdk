//
//  VTCTransaction.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTItem.h"
#import "VTAddress.h"
#import "VTCustomerDetails.h"

NS_ENUM(NSInteger, VTCTransactionRequestPaymentMethod) {
    VTCTransactionPaymentMethodUnspecified,
    VTCTransactionPaymentMethodOffers,
    VTCTransactionPaymentMethodCreditOrDebit,
    VTCTransactionPaymentMethodMandiriClickPay,
    VTCTransactionPaymentMethodCimbClicks,
    VTCTransactionPaymentMethodEpayBri,
    VTCTransactionPaymentMethodBbmMoney,
    VTCTransactionPaymentMethodIndosatDompetku,
    VTCTransactionPaymentMethodMandiriEcash,
    VTCTransactionPaymentMethodPermataVaBankTransfer,
    VTCTransactionPaymentMethodMandiriBillPayment,
    VTCTransactionPaymentMethodIndomaret,
};

NS_ENUM(NSInteger, VTCTransactionRequestCardClickType) {
    VTCTransactionRequestCardClickTypeNone,
    VTCTransactionRequestCardClickTypeOneClick,
    VTCTransactionRequestCardClickTypeTwoClick,
};

@interface VTCTransactionRequest : NSObject

@property (nonatomic, readonly) NSString* orderId;
@property (nonatomic, readonly) Float32 amount;
@property (nonatomic, readonly) enum VTCTransactionRequestPaymentMethod paymentMethod;
@property (nonatomic, readwrite) BOOL isSecureCard;
@property (nonatomic, readwrite) enum VTCTransactionRequestCardClickType cardClickType;
@property (nonatomic, readonly) NSMutableDictionary<NSString*, NSString*> *billInfo;
@property (nonatomic, readonly) NSMutableArray<VTItem *> *items;
@property (nonatomic, readwrite) VTAddress* billingAddress;
@property (nonatomic, readwrite) VTAddress* shippingAddress;
@property (nonatomic, readwrite) VTCustomerDetails* customerDetails;
@property (nonatomic, readwrite) BOOL useUi;

- (instancetype)initWithOrderId:(NSString *)orderId
                         amount:(Float32)amount
                  paymentMethod:(enum VTCTransactionRequestPaymentMethod)paymentMethod;

- (instancetype)initWithOrderId:(NSString *)orderId
                         amount:(Float32)amount;

@end
