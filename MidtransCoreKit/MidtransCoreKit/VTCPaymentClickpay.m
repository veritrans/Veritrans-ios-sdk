//
//  VTCPaymentClickpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCPaymentClickpay.h"
#import "VTNetworking.h"
#import "VTConfig.h"

@interface VTCPaymentClickpay()
@property (nonatomic, readwrite) VTMandiriClickpay *clickpay;
@end

@implementation VTCPaymentClickpay

- (void)chargeWithClickpay:(VTMandiriClickpay *)clickpay callback:(void (^)(id, NSError *))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"charge"];
    NSDictionary *param = @{@"payment_type":@"mandiri_clickpay",
                            @"mandiri_clickpay":[_clickpay requestData],
                            @"transaction_details":[self transactionDetail],
                            @"customer_details":[self.user customerDetails]};
    
    [[VTNetworking sharedInstance] postToURL:URL parameters:param callback:^(id response, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        } else {
            
        }
    }];
}

@end
