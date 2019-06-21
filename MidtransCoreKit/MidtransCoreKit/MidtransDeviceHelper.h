//
//  MidtransDeviceHelper.h
//  MidtransCoreKit
//
//  Created by Arie on 11/15/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MidtransDeviceHelper : NSObject
+ (NSString *)deviceToken;
+ (CGSize)screenSize;
+ (NSString *)deviceLanguage;
+ (NSString *)deviceModel;
+ (NSString *)deviceName;
+ (NSString *)deviceCurrentLanguage;
+ (NSNumber *)currentCPUUsage;
+ (NSString *)applicationName;
+ (NSString *)applicationVersion;
@end
