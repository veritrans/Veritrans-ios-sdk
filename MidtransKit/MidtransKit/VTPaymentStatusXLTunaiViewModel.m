//
//  VTPaymentStatusXLTunaiViewModel.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentStatusXLTunaiViewModel.h"

NSString *const kXLTunaiExpiration = @"xl_expiration";
NSString *const kXLTunaiMerchantID = @"xl_tunai_merchant_id";
NSString *const kXLTunaiOrderID = @"xl_tunai_order_id";

@interface VTPaymentStatusXLTunaiViewModel()
@property (nonatomic) NSString *xlOrderID;
@property (nonatomic) NSString *xlMerchantID;
@property (nonatomic) NSString *xlExpiration;
@end

@implementation VTPaymentStatusXLTunaiViewModel

- (instancetype)initWithTransactionResult:(MidtransTransactionResult *)transactionResult {
    if (self = [super initWithTransactionResult:transactionResult]) {
        self.xlOrderID = transactionResult.additionalData[kXLTunaiOrderID];
        self.xlMerchantID = transactionResult.additionalData[kXLTunaiMerchantID];
        self.xlExpiration = transactionResult.additionalData[kXLTunaiExpiration];
    }
    return self;
}

@end
