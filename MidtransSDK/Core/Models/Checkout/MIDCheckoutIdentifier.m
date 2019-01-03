//
//  MIDCheckoutIdentifier.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 02/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDCheckoutIdentifier.h"

@implementation MIDCheckoutIdentifier {
    NSString *_identifier;
}

- (NSDictionary *)dictionaryValue {
    return @{@"user_id":_identifier};
}

- (instancetype)initWithUserIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        _identifier = identifier;
    }
    return self;
}

@end
