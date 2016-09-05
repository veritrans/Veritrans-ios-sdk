//
//  BankTransferViewController.h
//  VTDirectDemo
//
//  Created by Arie on 9/5/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransactionTokenResponse,PaymentRequestBankTransfer;
@interface BankTransferViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) TransactionTokenResponse *transactionToken;
@property (nonatomic,strong) PaymentRequestBankTransfer *bankList;
@end
