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

+ (id)sharedClient;

- (void)performCreditCardTransaction:(VTCTransactionData *)transaction completion:(void(^)(id response, NSError *error))completion;

@end
