//
//  SNPPostPaymentGeneralView.h
//  MidtransKit
//
//  Created by Vanbungkring on 6/9/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransUINextStepButton;
@interface SNPPostPaymentGeneralView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *finishPaymentButton;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@end
