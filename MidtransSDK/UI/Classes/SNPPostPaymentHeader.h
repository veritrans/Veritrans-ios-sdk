//
//  SNPPostPaymentHeader.h
//  MidtransKit
//
//  Created by Vanbungkring on 4/16/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNPPostPaymentHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabSwitch;
@property (weak, nonatomic) IBOutlet UITextField *vaTextField;
@property (weak, nonatomic) IBOutlet UILabel *expiredTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tutorialTitleLabel;
//@property (weak, nonatomic) IBOutlet UIButton *copyVaNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *vaCopyButton;
@property (weak, nonatomic) IBOutlet UIView *expiredTimeBackground;
@property (weak, nonatomic) IBOutlet UILabel *topTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postPaymentBottom;

@end
