//
//  VTMerchantAuth.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTMerchantAuth : NSObject

- (id)initWithKey:(NSString *)key value:(id)value;

- (NSDictionary *)dictinaryValue;

@end
