//
//  MidtransNewCreditCardView.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransUITextField;
@class MIdtransUIBorderedView;
@class MidtransTransactionTokenResponse,MidtransUINextStepButton,MidtransPaymentMethodHeader;
@interface MidtransNewCreditCardView : UIView
@property (weak, nonatomic) IBOutlet MidtransUITextField *creditCardNumberTextField;
@property (weak, nonatomic) IBOutlet MidtransUITextField *cardExpireTextField;
@property (weak, nonatomic) IBOutlet MidtransUITextField *cardCVVNumberTextField;
@property (weak, nonatomic) IBOutlet UITableView *addOnTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addOnTableViewHeightConstraints;
@property (weak, nonatomic) IBOutlet UIView *secureBadgeWrapper;
@property (weak, nonatomic) IBOutlet UIView *installmentView;
@property (weak, nonatomic) IBOutlet UIButton *cvvInfoButton;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *installmentWrapperViewConstraints;
@property (nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *secureBadgeImage;
@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *finishPaymentButton;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountPrice;
- (void)configureAmountTotal:(MidtransTransactionTokenResponse *)tokenResponse;
- (BOOL)isViewableError:(NSError *)error;
- (UIImage *)iconDarkWithNumber:(NSString *)number;
- (UIImage *)iconWithNumber:(NSString *)number;
- (UIImage *)iconWithBankName:(NSString *)bankName;
@end
