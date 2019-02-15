//
//  VTPaymentGeneralViewController.h
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import "MIDPaymentDetail.h"
#import "MidtransSDK.h"

@interface MidtransUIPaymentGeneralViewController : MidtransUIPaymentController

- (instancetype)initWithModel:(MIDPaymentDetail *)model;

@end
