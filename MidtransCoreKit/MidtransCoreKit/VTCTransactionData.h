//
//  VTCTransactionData.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VTCPaymentDetails.h"
#import "VTCTransactionDetails.h"
#import "VTCCustomerDetails.h"
#import "VTItem.h"

/**
 An enumeration of supported payment type. This list is adapted from
 http://docs.veritrans.co.id/en/api/methods.html#Charge
 
 TODO: Comment/disable payment type that we don't support on the iOS.
 */
typedef NS_ENUM(NSInteger, VTCTransactionDataPaymentType) {
    VTCTransactionDataPaymentTypeUnspecified,
    VTCTransactionDataPaymentTypeCreditCard,
    VTCTransactionDataPaymentTypeBankTransfer,
    VTCTransactionDataPaymentTypeMandiriClickpay,
    VTCTransactionDataPaymentTypeCimbClicks,
    VTCTransactionDataPaymentTypeBcaKlikpay,
    VTCTransactionDataPaymentTypeBriEpay,
    VTCTransactionDataPaymentTypeTelkomselCash,
    VTCTransactionDataPaymentTypeXlTunai,
    VTCTransactionDataPaymentTypeEchannel,
    VTCTransactionDataPaymentTypeMandiriEcash,
    VTCTransactionDataPaymentTypeBbmMoney,
    VTCTransactionDataPaymentTypeCstore,
    VTCTransactionDataPaymentTypeIndosatDompetku,
};

/**
 VTCTransactionData contains all the data needed to do a transaction.
 */
@interface VTCTransactionData : NSObject

@property (nonatomic, readonly) enum VTCTransactionDataPaymentType paymentType;
@property (nonatomic, readonly) id<VTCPaymentDetails> paymentDetails;
@property (nonatomic, readonly) VTCTransactionDetails *transactionDetails;
@property (nonatomic, readonly) VTCCustomerDetails *customerDetails;
@property (nonatomic, readonly) NSArray<VTItem*> *itemDetails;

+ (instancetype)bankPermataTransactionWithDetails:(VTCTransactionDetails *)transactionDetails
                                  customerDetails:(VTCCustomerDetails *)customerDetails
                                      itemDetails:(NSArray<VTItem *> *)itemDetails;

- (instancetype)initWithPaymentType:(enum VTCTransactionDataPaymentType)paymentType
                     paymentDetails:(id<VTCPaymentDetails>)paymentDetails
                 transactionDetails:(VTCTransactionDetails *)transactionDetails
                    customerDetails:(VTCCustomerDetails *)customerDetails
                        itemDetails:(NSArray<VTItem*> *)itemDetails;

- (NSDictionary *)dictionaryValue;

@end
