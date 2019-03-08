//
//  MIDModelHelper.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 05/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDModelHelper.h"

@implementation MIDPaymentResult (utils)

- (NSString *)codeForLocalization {
    switch (self.statusCode) {
            case 200:
            return @"error_200";
            case 201:
            return @"error_201";
            case 202:
            return @"error_202";
            case 400:
            return @"error_400";
            case 502:
            return @"error_502";
            case 406:
            return @"error_406";
            case 407:
            return @"error_407";
            case 500:
            return @"error_500";
        default:
            return @"error_others";
    }
}

@end
