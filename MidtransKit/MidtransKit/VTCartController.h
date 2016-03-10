//
//  VTCartController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/VTCustomerDetails.h>

@interface VTCartController : UIViewController
@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) VTCustomerDetails *customer;

+ (instancetype)cartWithCustomer:(VTCustomerDetails *)customer andItems:(NSArray *)items;
@end
