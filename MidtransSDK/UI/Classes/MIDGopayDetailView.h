//
//  MIDGopayDetailView.h
//  MidtransKit
//
//  Created by Vanbungkring on 11/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransUINextStepButton,MIdtransUIBorderedView;
@interface MIDGopayDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *merchantName;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *transactionDetailWrapper;
@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *finishPaymentButton;
@property (weak, nonatomic) IBOutlet UIView *topWrapperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishPaymentHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transactionBottomDetailConstraints;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImage;
@property (weak, nonatomic) IBOutlet UIButton *qrcodeReloadImage;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIView *qrcodeWrapperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomAmountConstraints;
@property (weak, nonatomic) IBOutlet UITableView *guideTableView;
@property (weak, nonatomic) IBOutlet UILabel *expireTimesLabel;

@end
