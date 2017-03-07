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
@property (weak, nonatomic) IBOutlet MidtransPaymentMethodHeader *paymentHeaderView;
- (void)configureAmountTotal:(MidtransTransactionTokenResponse *)tokenResponse;
@end
