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
#import "MIDCheckoutCustomer.h"
#import "MIDCheckoutItem.h"
#import "MIDToken.h"
#import "MIDPaymentInfo.h"
#import "MIDPayment.h"
#import "MIDPaymentResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDClient : NSObject

@property (readonly) NSString *clientKey;
@property (readonly) NSString *merchantServerURL;
@property (readonly) MIDEnvironment environment;

- (void)configureClientKey:(NSString *)clientKey
         merchantServerURL:(NSString *)merchantServerURL
               environment:(MIDEnvironment)environment;
+ (MIDClient *)shared;

- (void)checkoutWith:(MIDCheckoutTransaction *)transaction
             options:(NSArray <NSObject <MIDCheckoutOption>*> * _Nullable)options
          completion:(void (^_Nullable) (MIDToken *_Nullable token, NSError *_Nullable error))completion;

- (void)getPaymentInfoWithToken:(NSString *)token
                     completion:(void (^_Nullable) (MIDPaymentInfo *_Nullable info, NSError *_Nullable error))completion;

- (void)performPayment:(NSObject <MIDPayment>*)payment
                 token:(NSString *)token
            completion:(void (^_Nullable) (MIDPaymentResult *_Nullable result, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
