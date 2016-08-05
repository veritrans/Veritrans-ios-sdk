//
//  VTCPaymentBankTransfer.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTPaymentDetails.h"

typedef NS_ENUM(NSUInteger, VTVAType) {
    VTVATypeBCA,
    VTVATypeMandiri,
    VTVATypePermata,
    VTVATypeOther
};
@interface VTPaymentBankTransfer : NSObject<VTPaymentDetails>

@property (nonatomic, readonly) VTVAType type;

- (instancetype _Nonnull)initWithBankTransferType:(VTVAType)type token:(TransactionTokenResponse *_Nonnull)token email:(NSString *_Nullable)email;

@end
