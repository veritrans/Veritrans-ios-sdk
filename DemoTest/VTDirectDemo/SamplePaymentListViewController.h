//
//  SamplePaymentListViewController.h
//  VTDirectDemo
//
//  Created by Arie on 8/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MidtransTransactionTokenResponse;
@interface SamplePaymentListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MidtransTransactionTokenResponse *transactionToken;

@end
