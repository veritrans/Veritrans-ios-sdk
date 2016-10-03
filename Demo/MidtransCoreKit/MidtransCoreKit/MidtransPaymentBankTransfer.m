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
    NSString *typeString;
    switch (_type) {
        case VTVATypeMandiri:
            typeString = MIDTRANS_PAYMENT_ECHANNEL;
            break;
        case VTVATypeBCA:
            typeString = MIDTRANS_PAYMENT_BCA_VA;
            break;
        case VTVATypePermata:
            typeString = MIDTRANS_PAYMENT_PERMATA_VA;
            break;
        case VTVATypeOther:
            typeString = MIDTRANS_PAYMENT_ALL_VA;
            break;
    }
    return typeString;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":[self paymentType],
             @"customer_details":@{@"email":self.email}};
}

@end
