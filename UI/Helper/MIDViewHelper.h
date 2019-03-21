//
//  MIDViewHelper.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIDViewHelper : NSObject

@end

@interface UIApplication (utilities)
+ (UIViewController *)rootViewController;
@end

NS_ASSUME_NONNULL_END
