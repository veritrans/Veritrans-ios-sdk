//
//  VTPaymentDirectView.h
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransUITextField.h"
#import "MidtransUIButton.h"

@interface MidtransUIPaymentDirectView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmPaymentButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)initViewWithPaymentID:(NSString *)paymentMethodID email:(NSString *)email;
- (MidtransVAType)paymentTypeWithID:(NSString *)paymentMethodID ;
- (MidtransUITextField *)emailTextField;
- (UILabel *)instructionTitleLabel;

@end
