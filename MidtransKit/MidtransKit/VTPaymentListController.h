//
//  VTPaymentListController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTItemViewModel.h"
#import <MidtransCoreKit/VTCustomerDetails.h>

@interface VTPaymentListController : UIViewController
+ (instancetype)controllerWithCustomer:(VTCustomerDetails *)customer items:(NSArray *)items;
@end
