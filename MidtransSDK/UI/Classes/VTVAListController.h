//
//  VTVAListController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransUIPaymentController.h"
@class MidtransPaymentRequestV2Response;
@interface VTVAListController : MidtransUIPaymentController
@property (nonatomic,strong) MidtransPaymentRequestV2Response *paymentResponse;
@end
