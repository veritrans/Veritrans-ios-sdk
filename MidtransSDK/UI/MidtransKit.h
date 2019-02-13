//
//  MidtransKit.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 12/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIDNetworkEnums.h"
#import "MidtransUIFontSource.h"

#import "MidtransSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface MidtransKit : NSObject

+ (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MIDEnvironment)environment;

+ (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MIDEnvironment)environment
                     color:(UIColor *_Nullable)color
                      font:(MidtransUIFontSource *_Nullable)font;

+ (void)presentPaymentPageAt:(UIViewController *)presenter
                 transaction:(MIDCheckoutTransaction *)transaction
                     options:(NSArray <NSObject <MIDCheckoutable>*> *_Nullable)options;

@end

NS_ASSUME_NONNULL_END
