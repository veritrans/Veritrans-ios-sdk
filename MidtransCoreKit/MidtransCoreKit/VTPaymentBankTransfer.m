//
//  VTCPaymentBankTransfer.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentBankTransfer.h"
#import "VTHelper.h"

@interface VTPaymentBankTransfer()

@property (nonatomic, readwrite) VTVAType type;

@end

@implementation VTPaymentBankTransfer

- (instancetype)initWithBankTransferType:(VTVAType)type {
    if (self = [super init]) {
        self.type = type;
    }
    
    return self;
}

- (NSString *)paymentType {
    NSString *typeString;
    switch (_type) {
        case VTVATypeMandiri:
            typeString = VT_PAYMENT_ECHANNEL;
            break;
        case VTVATypeBCA:
        case VTVATypePermata:
        case VTVATypeOther:
            typeString = VT_PAYMENT_BANK_TRANSFER;
            break;
    }
    return typeString;
}

- (NSDictionary *)dictionaryValue {
    // The format MUST BE compatible with JSON that described in
    // http://docs.veritrans.co.id/en/api/methods.html#bank_transfer_attr
    
    switch (_type) {
        case VTVATypeMandiri: {
            return @{@"bill_info1":@"demo_label",
                     @"bill_info2":@"demo_value"};
        }
        case VTVATypePermata: {
            return @{@"bank": @"permata"};
        }
        case VTVATypeBCA: {
            return @{@"bank": @"bca"};
        }
        case VTVATypeOther: {
            return @{@"bank": @"unknown"};
        }
    }
}

@end
