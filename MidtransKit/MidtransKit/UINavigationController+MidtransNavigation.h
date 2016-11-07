//
//  UINavigationController+MidtransNavigation.h
//  MidtransKit
//
//  Created by Arie on 11/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MidtransPaymentListModel,MidtransPaymentRequestV2Response,MidtransTransactionTokenResponse;
@interface UINavigationController (MidtransNavigation)
- (void)navigateToPaymentPage:(MidtransPaymentListModel *)paymentListModel withTransactionRequest:(MidtransPaymentRequestV2Response *)response andToken:(MidtransTransactionTokenResponse *)token;
@end
