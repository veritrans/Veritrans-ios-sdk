//
//  MIDCheckoutRequest.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDTransaction.h"
#import "MIDCustomer.h"
#import "MIDItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCheckoutRequest : NSObject

@property (nonatomic) MIDTransaction *transaction;
@property (nonatomic, nullable) MIDCustomer *customer;
@property (nonatomic, nullable) NSArray <MIDItem *> *items;

@property (nonatomic, nullable) NSString *customField1;
@property (nonatomic, nullable) NSString *customField2;
@property (nonatomic, nullable) NSString *customField3;

- (instancetype)initWithTransaction:(MIDTransaction *)transaction;
- (NSDictionary *)dictionaryValue;

@end

NS_ASSUME_NONNULL_END
