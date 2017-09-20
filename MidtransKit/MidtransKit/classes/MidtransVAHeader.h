//
//  MidtransVAHeader.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransUITextField.h"

@interface MidtransVAHeader : UITableViewCell
@property (strong, nonatomic) IBOutlet MidtransUITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tabSwitch;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keySMSviewConstraints;
@property (weak, nonatomic) IBOutlet UIView *keyView;
@property (strong, nonatomic) IBOutlet UILabel *tutorialTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *otherAtmIconsImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherAtmIconsHeightLayoutConstraint;
@end
