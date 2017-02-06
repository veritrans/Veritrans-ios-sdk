//
//  MidtransPromoEngine.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/6/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransPromoEngine.h"
#import "MidtransConfig.h"
#import "MidtransNetworking.h"

static NSString *const vPromoEngineBaseURL = @"https://promo.vt-stage.info/v2";
static NSString *const eObtainPromo = @"promo/obtain_promo";

@implementation MidtransPromoEngine

+ (void)obtainPromo:(MidtransPromo *)promo withPaymentAmount:(NSNumber *)amount completion:(void(^)(MidtransObtainedPromo *obtainedPromo, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@?promo_id=%@&amount=%@&client_key=%@",
                     vPromoEngineBaseURL,
                     eObtainPromo,
                     @(promo.promoIdentifier),
                     amount,
                     CONFIG.clientKey
                     ];
    [[MidtransNetworking shared] postToURL:URL parameters:nil callback:^(id response, NSError *error) {
        MidtransObtainedPromo *obtainedPromo;
        if (response) {
            obtainedPromo = [MidtransObtainedPromo modelObjectWithDictionary:response];
        }
        
        if (completion) {
            completion(obtainedPromo, error);
        }
    }];
}

@end
