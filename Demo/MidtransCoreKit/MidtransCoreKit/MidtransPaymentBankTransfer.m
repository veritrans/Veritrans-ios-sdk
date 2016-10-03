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
@property (nonatomic) MidtransTransactionTokenResponse *token;

@end

@implementation MidtransPaymentBankTransfer

- (instancetype _Nonnull)initWithBankTransferType:(MidtransVAType)type token:(MidtransTransactionTokenResponse *_Nonnull)token email:(NSString *_Nullable)email {
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
            typeString = MIDTRANS_PAYMENT_ECHANNEL;
            break;
        case VTVATypeBCA:
        case VTVATypePermata:
        case VTVATypeOther:
            typeString = MIDTRANS_PAYMENT_BANK_TRANSFER;
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

- (MidtransTransactionTokenResponse *)snapToken {
    return self.token;
}
@end
