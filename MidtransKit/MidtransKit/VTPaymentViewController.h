//
//  VTPaymentViewController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/VTItem.h>
#import <MidtransCoreKit/VTUser.h>

@interface VTPaymentViewController : UINavigationController

+ (instancetype)paymentWithUser:(VTUser *)user andItems:(NSArray <VTItem *> *)items;

@end
