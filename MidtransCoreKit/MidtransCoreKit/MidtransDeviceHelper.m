//
//  MidtransDeviceHelper.m
//  MidtransCoreKit
//
//  Created by Arie on 11/15/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransDeviceHelper.h"
#import "MidtransConstant.h"
#import <ifaddrs.h>
#import <UIKit/UIKit.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import <sys/utsname.h>
@implementation MidtransDeviceHelper
+ (NSString *)deviceToken {
     return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
+ (NSString *)deviceModel {
    size_t size = 100;
    char *hw_machine = malloc(size);
    int name[] = {CTL_HW, HW_MACHINE};
    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}
+ (NSString *)deviceCurrentLanguage {
    NSString * lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *languageDic = [NSLocale componentsFromLocaleIdentifier:lang];
    return [languageDic objectForKey:@"kCFLocaleLanguageCodeKey"];

}
+ (NSString *)deviceLanguage {
    return [[NSBundle mainBundle].preferredLocalizations count]?(NSString *)[NSBundle mainBundle].preferredLocalizations:@"ID";
}
+(NSString *)deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
@end
