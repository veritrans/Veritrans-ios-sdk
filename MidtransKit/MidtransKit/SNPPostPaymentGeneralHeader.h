//
//  SNPPostPaymentGeneralHeader.h
//  MidtransKit
//
//  Created by Vanbungkring on 6/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNPPostPaymentGeneralHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *vaTextField;
@property (weak, nonatomic) IBOutlet UILabel *expiredTimeLabel;
//@property (weak, nonatomic) IBOutlet UIButton *copyVaNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *vaCopyButton;
@property (weak, nonatomic) IBOutlet UIView *expiredTimeBackground;
@property (weak, nonatomic) IBOutlet UILabel *topTextLabel;
@end
