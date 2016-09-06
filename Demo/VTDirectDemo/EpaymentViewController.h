//
//  EpaymentViewController.h
//  VTDirectDemo
//
//  Created by Arie on 9/5/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransTransactionTokenResponse,PaymentRequestBankTransfer,VTPaymentListModel;
@interface EpaymentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *transactionAmount;
@property (weak, nonatomic) IBOutlet UILabel *transactionID;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (nonatomic,strong) MidtransTransactionTokenResponse *transactionToken;
@property (nonatomic, strong) VTPaymentListModel *paymentMethod;
@end
