//
//  BankTransferViewController.h
//  VTDirectDemo
//
//  Created by Arie on 9/5/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransTransactionTokenResponse,MidtransPaymentRequestBankTransfer;
@interface BankTransferViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) MidtransTransactionTokenResponse *transactionToken;
@property (nonatomic,strong) MidtransPaymentRequestBankTransfer *bankList;
@end
