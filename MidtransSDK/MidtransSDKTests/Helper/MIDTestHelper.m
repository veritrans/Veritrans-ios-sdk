//
//  MIDTestHelpers.m
//  MidtransSDKTests
//
//  Created by Nanang Rafsanjani on 07/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDTestHelper.h"

@implementation MIDTestHelper

+ (NSString *)orderID {
    return [NSString stringWithFormat:@"%f", [NSDate new].timeIntervalSince1970];
}

+ (void)setup {
    [MIDClient configureClientKey:@"VT-client-UlfSUChIo-KM9sne"
                merchantServerURL:@"https://juki-merchant-server.herokuapp.com/charge/index.php"
                      environment:MIDEnvironmentSandbox];
}

@end

@implementation XCTestCase (helper)

- (void)getTokenWithCompletion:(void (^_Nullable) (NSString *_Nullable token, NSError *_Nullable error))completion {
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:[MIDTestHelper orderID]
                                                                      grossAmount:@20000
                                                                         currency:MIDCurrencyIDR];
    
    [MIDClient checkoutWith:trx options:nil completion:^(MIDToken * _Nullable token, NSError * _Nullable error) {
        NSString *_token = token.token;
        XCTAssertNotNil(_token);
        completion(_token, error);
    }];
}

@end
