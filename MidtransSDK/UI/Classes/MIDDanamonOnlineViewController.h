//
//  MIDDanamonOnlineViewController.h
//  MidtransKit
//
//  Created by Tommy.Yohanes on 23/05/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
@class MIdtransUIBorderedView;

@interface MIDDanamonOnlineViewController : MidtransUIPaymentController
@property (weak, nonatomic) IBOutlet UILabel *danamonStepLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@end
