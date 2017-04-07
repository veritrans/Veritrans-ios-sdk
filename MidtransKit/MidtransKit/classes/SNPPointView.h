//
//  SNPPointView.h
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransPaymentMethodHeader,MidtransTransactionTokenResponse;
@interface SNPPointView : UIView
@property (weak, nonatomic) IBOutlet UITextField *finalAmountTextField;
@property (weak, nonatomic) IBOutlet UIView *pointViewWrapper;
@property (weak, nonatomic) IBOutlet UITextField *pointInputTextField;
@property (weak, nonatomic) IBOutlet UILabel *pointTotalTtitle;

@property (weak, nonatomic) IBOutlet MidtransPaymentMethodHeader *paymentHeaderView;
- (void)configureAmountTotal:(MidtransTransactionTokenResponse *)tokenResponse;
@end
