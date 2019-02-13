//
//  MIDPaymentController.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 12/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransSDK.h"
#import "MidtransUIPaymentController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDPaymentController : UIViewController

- (instancetype)initWithTransaction:(MIDCheckoutTransaction *)transaction
                            options:(NSArray <NSObject <MIDCheckoutable>*> *_Nullable)options;

@end

NS_ASSUME_NONNULL_END
