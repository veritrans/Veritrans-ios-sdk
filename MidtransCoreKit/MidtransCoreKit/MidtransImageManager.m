//
//  VTImageManager.m
//  MidtransCoreKit
//
//  Created by Arie on 8/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransImageManager.h"
#import "MidtransConstant.h"
@implementation MidtransImageManager
+(void)getImageFromURLwithUrl:(NSString*)imageUrlString {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrlString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:MIDTRANS_CORE_MERCHANT_LOGO_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    });
}
+(UIImage *)merchantLogo {
    return [UIImage imageWithData:(NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_MERCHANT_LOGO_KEY]];
}
@end
