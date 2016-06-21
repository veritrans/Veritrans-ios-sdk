//
//  VTPaymentDirectView.h
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VTTextField, VTButton;
@interface VTPaymentDirectView : UIView
@property (weak, nonatomic) IBOutlet VTTextField *directPaymentTextField;
@property (weak, nonatomic) IBOutlet UILabel *vtInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet VTButton *howToPaymentButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmPaymentButton;

@end
