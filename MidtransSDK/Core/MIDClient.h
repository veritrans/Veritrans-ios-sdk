//
//  MIDClient.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDNetworkEnums.h"
#import "MIDCheckoutTransaction.h"
#import "MIDCustomerDetails.h"
#import "MIDCheckoutItems.h"
#import "MIDToken.h"
#import "MIDPaymentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDClient : NSObject

+ (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MIDEnvironment)environment;

+ (void)checkoutWith:(MIDCheckoutTransaction *)transaction
             options:(NSArray <NSObject <MIDCheckoutable>*> *_Nullable)options
          completion:(void (^_Nullable) (MIDToken *_Nullable token, NSError *_Nullable error))completion;

+ (void)getPaymentInfoWithToken:(NSString *)token
                     completion:(void (^_Nullable) (MIDPaymentInfo *_Nullable info, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
