//
//  VTPaymentMandiriClickpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentMandiriClickpay.h"
#import "VTNetworking.h"

@implementation VTPaymentMandiriClickpay



- (void)payWithData:(VTMandiriClickpay *)data callback:(void(^)(id response, NSError *error))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] baseUrl], @"token"];
    NSDictionary *param = @{@"payment_type":@"mandiri_clickpay",
                            @"mandiri_clickpay":[data requestData],
                            @"transaction_details":[self transactionDetail],
                            @"customer_details":[self.user customerDetails]
                            };
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:param callback:^(id response, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        } else {
            
        }
    }];
}

@end
