//
//  VTMerchantAuth.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMerchantAuth.h"

@interface VTMerchantAuth()
@property (nonatomic) NSString *key;
@property (nonatomic) id value;
@end

@implementation VTMerchantAuth

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.key forKey:@"key"];
    [encoder encodeObject:self.value forKey:@"value"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.key = [decoder decodeObjectForKey:@"key"];
        self.value = [decoder decodeObjectForKey:@"value"];
    }
    return self;
}

- (id)initWithAuthData:(NSDictionary *)authData {
    self = [super init];
    if (self) {
        for (NSString *key in [authData allKeys]) {
            _key = key;
            _value = authData[key];
        }
    }
    return self;
}

- (NSDictionary *)dictinaryValue {
    return @{_key:_value};
}

@end
