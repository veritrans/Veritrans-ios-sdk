//
//  VTConfirmPaymentController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTConfirmPaymentController : UIViewController

+ (instancetype)controllerWithMaskedCardNumber:(NSString *)cardNumber grossAmount:(NSNumber *)amount callback:(void(^)(NSInteger selectedIndex))callback;

@end
