//
//  VTPaymentGuideViewController.h
//  MidtransKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentController.h"

@interface VTPaymentGuideViewController : VTPaymentController
- (instancetype)initGuideWithPaymentMethodName:(NSString *)paymentMethodName;
@end
