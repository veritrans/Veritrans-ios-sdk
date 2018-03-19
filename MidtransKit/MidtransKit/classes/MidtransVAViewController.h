//
//  MidtransVAViewController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
@class MidtransPaymentRequestV2Response;
@interface MidtransVAViewController : MidtransUIPaymentController
@property (nonatomic,strong) MidtransPaymentRequestV2Response *response;
@end
