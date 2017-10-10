//
//  VTPaymentGeneralView.h
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTGuideView.h"

@interface MidtransUIPaymentGeneralView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;
@property (weak, nonatomic) IBOutlet UIView *tokenView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tokenViewConstraints;
@property (weak, nonatomic) IBOutlet UILabel *tokenViewLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tokenViewIcon;
@property (strong, nonatomic) IBOutlet VTGuideView *guideView;
@end
