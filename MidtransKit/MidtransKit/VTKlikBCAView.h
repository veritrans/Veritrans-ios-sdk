//
//  VTKlikBCAView.h
//  MidtransKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VTTextField,VTButton;
@interface VTKlikBCAView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmPaymentButton;
@property (weak, nonatomic) IBOutlet VTTextField *userIdTextField;
@property (weak, nonatomic) IBOutlet VTButton *guidePaymentButton;

@end
