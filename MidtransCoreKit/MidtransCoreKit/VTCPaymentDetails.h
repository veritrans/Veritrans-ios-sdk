//
//  VTCPaymentDetails.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VTCPaymentDetails <NSObject>

- (NSString *)paymentType;

- (NSDictionary *)dictionaryValue;

@end
