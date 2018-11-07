//
//  MidtransPaymentGCIView.h
//  MidtransKit
//
//  Created by Vanbungkring on 12/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransUITextField;
@class MIdtransUIBorderedView;
@interface MidtransPaymentGCIView : UIView
@property (weak, nonatomic) IBOutlet MidtransUITextField *gciCardTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet MidtransUITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
//- (void)configurePaymentOptions:()
@end
