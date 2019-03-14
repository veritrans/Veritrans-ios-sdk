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
#import <mach/mach.h>
#import <assert.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import <sys/utsname.h>
@implementation MidtransDeviceHelper
+ (NSString *)deviceToken {
     return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
+ (CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}
+ (NSString *)applicationName {
    return (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)applicationVersion {
    return (NSString *)[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
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
    
    NSString *localeID = [[NSLocale.preferredLanguages.firstObject componentsSeparatedByString:@"_"] firstObject];
    NSDictionary *languageDic = [NSLocale componentsFromLocaleIdentifier:localeID];
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
+ (NSNumber *)currentCPUUsage{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return [NSNumber numberWithFloat:-1];
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return [NSNumber numberWithFloat:-1];
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < (int)thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return [NSNumber numberWithFloat:-1];
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return [NSNumber numberWithFloat:tot_cpu];
}
+ (NSString *)deviceCurrentNetwork {
    
    NSArray *subviews = nil;
    id statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        subviews = [[[statusBar valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    } else {
        subviews = [[statusBar valueForKey:@"foregroundView"] subviews];
    }
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSString *networkType = @"-";
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
        case 0:
            networkType = @"No wifi or cellular";
            break;
            
        case 1:
            networkType = @"2G";
            break;
            
        case 2:
            networkType = @"3G";
            break;
            
        case 3:
            networkType = @"4G";
            break;
            
        case 4:
            networkType = @"LTE";
            break;
            
        case 5:
            networkType = @"Wifi";
            break;
            
            
        default:
            networkType = @"-";
            break;
    }
    
    return networkType;
}

@end
