//
//  MidtransDeviceHelper.h
//  MidtransCoreKit
//
//  Created by Arie on 11/15/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidtransDeviceHelper : NSObject
+ (NSString *)deviceToken;
+ (NSString *)deviceLanguage;
+ (NSString *)deviceModel;
+ (NSString *)deviceName;
@end
