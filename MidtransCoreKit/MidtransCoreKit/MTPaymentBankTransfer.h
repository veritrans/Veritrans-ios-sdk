//
//  VTCPaymentBankTransfer.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTPaymentDetails.h"

typedef NS_ENUM(NSUInteger, MTVAType) {
    VTVATypeBCA,
    VTVATypeMandiri,
    VTVATypePermata,
    VTVATypeOther
};
@interface MTPaymentBankTransfer : NSObject<MTPaymentDetails>

@property (nonatomic, readonly) MTVAType type;

- (instancetype _Nonnull)initWithBankTransferType:(MTVAType)type token:(MTTransactionTokenResponse *_Nonnull)token email:(NSString *_Nullable)email;

@end
