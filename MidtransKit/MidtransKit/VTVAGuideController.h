//
//  VTVAGuideController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/VTPaymentBankTransfer.h>

#import "VTClassHelper.h"
#import "VTDetailedTitleController.h"

@interface VTVAGuideController : VTDetailedTitleController
+ (instancetype)controllerWithVAType:(VTVAType)vaType;
@end
