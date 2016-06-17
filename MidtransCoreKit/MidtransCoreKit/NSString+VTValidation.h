//
//  NSString+VTValidation.h
//  MidtransCoreKit
//
//  Created by Arie on 6/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VTValidation)
- (BOOL)isEmpty;
- (BOOL)isValidEmail;
- (BOOL)isValidCommonName;
- (BOOL)isValidNumber;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidUsingPlusPhoneNumber;
@end
