//
//  MIDUrlHandler.m
//  MidtransCoreKit
//
//  Created by Muhammad.Masykur on 01/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDUrlHandler.h"
#import "MidtransConstant.h"

@implementation MIDUrlHandler

+ (void)handleUrl:(NSURL *)url {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [url.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOPAY_STATUS object:params];
}
@end
