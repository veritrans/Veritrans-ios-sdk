//
//  MIDCustomField.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutOption.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCustomField : NSObject<MIDCheckoutOption>

@property (nonatomic) NSString *customField1;
@property (nonatomic) NSString *customField2;
@property (nonatomic) NSString *customField3;

- (instancetype)initWithCustomField1:(NSString *)customField1
                        customField2:(NSString *)customField2
                        customField3:(NSString *)customField3;

@end

NS_ASSUME_NONNULL_END
