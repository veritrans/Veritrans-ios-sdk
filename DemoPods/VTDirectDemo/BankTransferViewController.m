//
//  BankTransferViewController.m
//  VTDirectDemo
//
//  Created by Arie on 9/5/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "BankTransferViewController.h"
#import "SamplePaymentListTableViewCell.h"
#import "BankTransferDetailViewController.h"
#import <MBProgressHUD.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransPaymentListModel.h>
@interface BankTransferViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSArray *bankList;
@end

@implementation BankTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"virtualAccount" ofType:@"plist"];
    NSMutableArray *vaListM = [NSMutableArray new];
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];
    for (int i = 0; i<paymentList.count; i++) {
        MidtransPaymentListModel *paymentmodel= [[MidtransPaymentListModel alloc]initWithDictionary:paymentList[i]];
        [vaListM addObject:paymentmodel];
    }
    self.bankList = vaListM;
    [self.tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankList.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    id<MidtransPaymentDetails> paymentDetails;
    MidtransVAType paymentType;
     MidtransPaymentListModel *vaTypeModel = (MidtransPaymentListModel *)[self.bankList objectAtIndex:indexPath.row];
    if ([vaTypeModel.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_VA]) {
        paymentType = VTVATypeBCA;
    }
    else if ([vaTypeModel.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_ECHANNEL]) {
        paymentType = VTVATypeMandiri;
    }
    else if ([vaTypeModel.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA]) {
        paymentType = VTVATypePermata;
    }
    else if ([vaTypeModel.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_OTHER_VA]) {
        paymentType = VTVATypeOther;
    }
    else if ([vaTypeModel.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_ALL_VA]) {
        paymentType = VTVATypeOther;
    }
    
    /*
     put customer email here
     */
    paymentDetails = [[MidtransPaymentBankTransfer alloc] initWithBankTransferType:paymentType
                                                                             email:@"testing@mailinator.com"];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.transactionToken];
    
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"ERROR"
                                      message:error.description
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];

        }
        else {
            BankTransferDetailViewController *bankDtail =[[BankTransferDetailViewController alloc] initWithNibName:@"BankTransferDetailViewController" bundle:nil];
                                                          bankDtail.bankName = vaTypeModel.internalBaseClassIdentifier;
                                                          bankDtail.transactionData = result.transactionId;
           [self.navigationController pushViewController:bankDtail animated:YES];
                                                          }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransPaymentListModel *paymentMethod = self.bankList[indexPath.row];
    SamplePaymentListTableViewCell *cell = (SamplePaymentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SamplePaymentListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SamplePaymentListTableViewCell" owner:self options:nil] firstObject];
        [tableView registerNib:[UINib nibWithNibName:@"SamplePaymentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SamplePaymentListTableViewCell"];
    }
    [cell configurePaymetnList:paymentMethod];
    return cell;
}

@end
