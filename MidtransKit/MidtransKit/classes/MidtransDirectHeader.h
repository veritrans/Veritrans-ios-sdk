//
//  MidtransDirectHeader.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/15/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransUITextField.h"

@interface MidtransDirectHeader : UITableViewCell
@property (strong, nonatomic) IBOutlet MidtransUITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *tutorialTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *showInstructionsButton;
@end
