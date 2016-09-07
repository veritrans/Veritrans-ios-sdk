//
//  VTCPaymentBankTransfer.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidtransPaymentDetails.h"

typedef NS_ENUM(NSUInteger, MTVAType) {
    VTVATypeBCA,
    VTVATypeMandiri,
    VTVATypePermata,
    VTVATypeOther
};
@interface MTPaymentBankTransfer : NSObject<MidtransPaymentDetails>

@property (nonatomic, readonly) MTVAType type;

- (instancetype _Nonnull)initWithBankTransferType:(MTVAType)type token:(MidtransTransactionTokenResponse *_Nonnull)token email:(NSString *_Nullable)email;

@end
