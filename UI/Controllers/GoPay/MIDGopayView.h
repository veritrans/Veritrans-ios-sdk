//
//  MIDGopayView.h
//  MidtransKit
//
//  Created by Vanbungkring on 11/24/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransUINextStepButton,MIdtransUIBorderedView;
@interface MIDGopayView : UIView
@property (weak, nonatomic) IBOutlet UIView *gopayTopViewWrapper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gopayTopViewHeightConstraints;
@property (weak, nonatomic) IBOutlet UILabel *topNoticeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topNoticeLogo;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *transactionDetailWrapper;
@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *finishPaymentButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topWrapperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishPaymentHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transactionBottomDetailConstraints;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *installGojekButton;
@end
