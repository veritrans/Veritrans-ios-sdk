//
//  SNPPointView.h
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransTransactionTokenResponse;
@class MIdtransUIBorderedView,MidtransUINextStepButton;
@interface SNPPointView : UIView
@property (weak, nonatomic) IBOutlet UITextField *finalAmountTextField;
@property (weak, nonatomic) IBOutlet UIView *pointViewWrapper;
@property (weak, nonatomic) IBOutlet UITextField *pointInputTextField;
@property (weak, nonatomic) IBOutlet UILabel *pointTotalTtitle;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointBankImage;
@property (weak, nonatomic) IBOutlet UILabel *topTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *topTextfield;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@property (weak, nonatomic) IBOutlet UIButton *paymentWithoutPointButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payWithoutPointHeightConstraints;
@property (weak, nonatomic) IBOutlet UILabel *pointTopTile;
@property (weak, nonatomic) IBOutlet UILabel *pointBottomTitle;

- (void)configureAmountTotal:(MidtransTransactionTokenResponse *)tokenResponse;
@end
