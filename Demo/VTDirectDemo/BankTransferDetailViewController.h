//
//  BankTransferDetailViewController.h
//  VTDirectDemo
//
//  Created by Vanbungkring on 2/14/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankTransferDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *transactionDetail;
@property (nonatomic,strong) NSString *transactionData;
@property (nonatomic,strong) NSString *bankName;
@end
