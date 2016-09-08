//
//  VTAddCardView.h
//  MidtransKit
//
//  Created by Arie on 7/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>

#import "MidtransUITextField.h"
#import "VTCCFrontView.h"
#import "VTCCBackView.h"

@interface VTAddCardView : UIView
@property (weak, nonatomic) IBOutlet MidtransUITextField *cardNumber;
@property (weak, nonatomic) IBOutlet MidtransUITextField *cardExpiryDate;
@property (weak, nonatomic) IBOutlet MidtransUITextField *cardCvv;
@property (weak, nonatomic) IBOutlet UIScrollView *fieldScrollView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UISwitch *saveCardSwitch;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet VTCCFrontView *cardFrontView;
@property (weak, nonatomic) IBOutlet VTCCBackView *cardBackView;

- (void)setToken:(MidtransTransactionTokenResponse *)token;
- (BOOL)isViewError:(NSError *)error;

@end
