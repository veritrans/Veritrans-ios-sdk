//
//  VTCPaymentBankTransfer.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentBankTransfer.h"
#import "MidtransHelper.h"

@interface MidtransPaymentBankTransfer()

@property (nonatomic, readwrite) MidtransVAType type;
@property (nonatomic) NSString *email;

@end

@implementation MidtransPaymentBankTransfer

- (instancetype _Nonnull)initWithBankTransferType:(MidtransVAType)type email:(NSString *_Nullable)email {
    if (self = [super init]) {
        self.type = type;
        self.email = email;
    }
    return self;
}

- (NSString *)paymentType {
    switch (_type) {
        case VTVATypeMandiri:
            return MIDTRANS_PAYMENT_ECHANNEL;
        case VTVATypeAll:
            return MIDTRANS_PAYMENT_ALL_VA;
        case VTVATypeBCA:
            return MIDTRANS_PAYMENT_BCA_VA;
        case VTVATypePermata:
            return MIDTRANS_PAYMENT_PERMATA_VA;
        case VTVATypeBNI:
            return MIDTRANS_PAYMENT_BNI_VA;
        case VTVATypeOther:
            return MIDTRANS_PAYMENT_OTHER_VA;
    }
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":[self paymentType],
             @"customer_details":@{@"email":self.email}};
}

@end
