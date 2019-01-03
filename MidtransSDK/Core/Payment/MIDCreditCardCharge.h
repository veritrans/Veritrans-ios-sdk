//
//  MIDCreditCardCharge.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 11/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCreditCardResult.h"
#import "MIDModelEnums.h"
#import "MIDChargeInstallment.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCreditCardCharge : NSObject

+ (void)chargeWithToken:(NSString *)snapToken
              cardToken:(NSString *)cardToken
                   save:(BOOL)save
            installment:(MIDChargeInstallment *_Nullable)installment
                  point:(NSNumber *_Nullable)point
             completion:(void (^_Nullable)(MIDCreditCardResult *_Nullable result, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
