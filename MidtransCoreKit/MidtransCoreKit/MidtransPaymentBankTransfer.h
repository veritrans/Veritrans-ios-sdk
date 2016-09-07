//
//  VTCPaymentBankTransfer.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPaymentDetails.h"

typedef NS_ENUM(NSUInteger, MidtransVAType) {
    VTVATypeBCA,
    VTVATypeMandiri,
    VTVATypePermata,
    VTVATypeOther
};
@interface MidtransPaymentBankTransfer : NSObject<MidtransPaymentDetails>

@property (nonatomic, readonly) MidtransVAType type;

- (instancetype _Nonnull)initWithBankTransferType:(MidtransVAType)type token:(MidtransTransactionTokenResponse *_Nonnull)token email:(NSString *_Nullable)email;

@end
