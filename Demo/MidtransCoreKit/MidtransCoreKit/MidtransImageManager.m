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
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrlString]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:MIDTRANS_CORE_MERCHANT_LOGO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(UIImage *)merchantLogo {
    return [UIImage imageWithData:(NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_MERCHANT_LOGO_KEY]];
}
@end
