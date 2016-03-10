//
//  Veritrans.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTPaymentDelegate.h"
#import "VTCTransactionData.h"

@interface Veritrans : NSObject

@property (nonatomic, weak) id<VTPaymentDelegate> delegate;

+ (id)sharedInstance;
- (void)payUsingPermataBankForTransaction:(VTCTransactionData *)transactionData;

@end
