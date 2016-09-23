//
//  MidtransWidgetHelper.m
//  MIdtransWidget
//
//  Created by Arie on 9/23/16.
//  Copyright © 2016 Arie. All rights reserved.
//

#import "MidtransWidgetHelper.h"
#define MidtransWidgetBundle [MidtransWidgetHelper kitBundle]

@implementation MidtransWidgetHelper

+ (NSBundle*)kitBundle {
    static dispatch_once_t onceToken;
    static NSBundle *kitBundle = nil;
    dispatch_once(&onceToken, ^{
        //check if bundle is in dynamic framework
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks/MidtransWidget.framework/MidtransWidget.framework"
                                                   withExtension:@"bundle"];
        if (!bundleURL) {
            bundleURL = [[NSBundle mainBundle] URLForResource:@"MidtransWidget.framework"
                                                withExtension:@"bundle"];
        }
        kitBundle = [NSBundle bundleWithURL:bundleURL];

    });
    return kitBundle;
}

@end
