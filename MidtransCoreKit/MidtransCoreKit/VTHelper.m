//
//  VTHelper.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTHelper.h"

@implementation VTHelper

+ (id)nullifyIfNil:(id)object {
    if (object) {
        return object;
    } else {
        return [NSNull null];
    }
}

@end
