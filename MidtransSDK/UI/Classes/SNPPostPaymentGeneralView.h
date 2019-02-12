//
//  SNPPostPaymentGeneralView.h
//  MidtransKit
//
//  Created by Vanbungkring on 6/9/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransUINextStepButton;
@class MIdtransUIBorderedView;
@interface SNPPostPaymentGeneralView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *finishPaymentButton;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;

@end
