//
//  NSString+VTValidation.h
//  MidtransCoreKit
//
//  Created by Arie on 6/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MidtransValidation)
- (BOOL)SNPisEmpty;
- (BOOL)SNPisValidEmail;
- (BOOL)SNPisValidCommonName;
- (BOOL)SNPisValidNumber;
- (BOOL)SNPisValidPhoneNumber;
- (BOOL)SNPisValidUsingPlusPhoneNumber;

- (BOOL)SNPisValidClickpayNumber;
- (BOOL)SNPisValidClickpayToken;

@end
