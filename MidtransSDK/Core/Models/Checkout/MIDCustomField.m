//
//  MIDCustomField.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCustomField.h"

@implementation MIDCustomField

- (NSDictionary *)dictionaryValue {
    return @{@"custom_field1": self.customField1,
             @"custom_field2": self.customField2,
             @"custom_field3": self.customField3
             };
}

- (instancetype)initWithCustomField1:(NSString *)customField1
                        customField2:(NSString *)customField2
                        customField3:(NSString *)customField3 {
    if (self = [super init]) {
        self.customField1 = customField1;
        self.customField2 = customField3;
        self.customField3 = customField3;
    }
    return self;
}

@end
