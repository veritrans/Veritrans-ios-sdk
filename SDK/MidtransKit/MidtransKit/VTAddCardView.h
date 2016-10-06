//
//  VTAddCardView.h
//  MidtransKit
//
//  Created by Arie on 7/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransUICardFormatter.h"
#import "MidtransUITextField.h"
#import "MidtransUICCFrontView.h"
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
@property (weak, nonatomic) IBOutlet MidtransUICCFrontView *cardFrontView;
@property (weak, nonatomic) IBOutlet VTCCBackView *cardBackView;
@property (weak, nonatomic) IBOutlet UIButton *scanCardButton;
@property (weak, nonatomic) IBOutlet UIView *scanCardViewWrapper;
@property (nonatomic) MidtransUICardFormatter *ccFormatter;
- (void)setCardNumberFromCardIOSDK:(NSDictionary *)cardInformation;
- (void)setToken:(MidtransTransactionTokenResponse *)token;
- (BOOL)isViewError:(NSError *)error;
- (void)formatter_didTextFieldChange:(MidtransUICardFormatter *)formatter;
- (UIImage *)iconDarkWithNumber:(NSString *)number;
- (UIImage *)iconWithNumber:(NSString *)number;
@end
