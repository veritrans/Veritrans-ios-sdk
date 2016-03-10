//
//  VTCustomerDetails.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTCustomerDetails : NSObject

@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *phone;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone;

- (NSDictionary *)dictionaryValue;

@end
