//
//  VTMerchantClient.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTCTransactionData.h"

@interface VTMerchantClient : NSObject

- (void)performCreditCardTransaction:(VTCTransactionData *)transaction;

- (void)performCreditCardTransaction:(VTCTransactionData *)transaction
                         withTokenId:(NSString *)token;

@end
