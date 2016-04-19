//
//  VTTwoClickController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/4/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransCoreKit/VTCustomerDetails.h"

#import "VTCCBackView.h"

@interface VTTwoClickController : UIViewController
@property (weak, nonatomic) IBOutlet VTCCBackView *backView;

+ (instancetype)controllerWithCustomer:(VTCustomerDetails *)customer items:(NSArray *)items savedTokenId:(NSString *)savedTokenId;

@end
