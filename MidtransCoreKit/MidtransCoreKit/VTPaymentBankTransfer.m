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
@property (nonatomic) NSString *email;
@property (nonatomic) MTTransactionTokenResponse *token;

@end

@implementation VTPaymentBankTransfer

- (instancetype _Nonnull)initWithBankTransferType:(VTVAType)type token:(MTTransactionTokenResponse *_Nonnull)token email:(NSString *_Nullable)email {
    if (self = [super init]) {
        self.type = type;
        self.email = email;
        self.token = token;
    }
    
    return self;
}

- (NSString *)paymentType {
    NSString *typeString;
    switch (_type) {
        case VTVATypeMandiri:
            typeString = MT_PAYMENT_ECHANNEL;
            break;
        case VTVATypeBCA:
        case VTVATypePermata:
        case VTVATypeOther:
            typeString = MT_PAYMENT_BANK_TRANSFER;
            break;
    }
    return typeString;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token.tokenId,
             @"email_address":self.email};
}

- (NSString *)chargeURL {
    switch (self.type) {
        case VTVATypeBCA:
            return ENDPOINT_CHARGE_BCA_VA;
        case VTVATypeMandiri:
            return ENDPOINT_CHARGE_MANDIRI_VA;
        case VTVATypePermata:
            return ENDPOINT_CHARGE_PERMATA_VA;
        default:
            return ENDPOINT_CHARGE_OTHER_VA;
    }
}

- (MTTransactionTokenResponse *)snapToken {
    return self.token;
}
@end
