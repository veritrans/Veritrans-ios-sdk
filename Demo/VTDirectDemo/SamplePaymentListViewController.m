//
//  SamplePaymentListViewController.m
//  VTDirectDemo
//
//  Created by Arie on 8/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "SamplePaymentListViewController.h"
#import "PaymentCreditCardViewController.h"
#import <MBProgressHUD.h>
#import "EpaymentViewController.h"
#import "BankTransferViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransPaymentListModel.h>
#import "SamplePaymentListTableViewCell.h"
@interface SamplePaymentListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *paymentList;
@property (nonatomic, strong) MidtransPaymentRequestResponse *paymentRequestResponse;
@property (nonatomic,strong)NSMutableArray *paymentMethodList;
@end

@implementation SamplePaymentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentMethodList = [NSMutableArray new];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(dismissModalViewControllerAnimated:)];
    
    self.navigationItem.leftBarButtonItem = doneButton;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"paymentlist" ofType:@"plist"];
    self.paymentList = [NSArray arrayWithContentsOfFile:path];
    
//    [[MidtransMerchantClient sharedClient] requestPaymentlistWithToken:self.transactionToken.tokenId
//                                                            completion:^(MidtransPaymentRequestResponse * _Nullable response, NSError * _Nullable error)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         self.title = response.merchantData.displayName;
//         if (response) {
//             NSInteger grandTotalAmount = [response.transactionData.transactionDetails.amount integerValue];
//             // [self.tableView reloadData];
//             self.paymentRequestResponse = response;
//             if (self.paymentRequestResponse.transactionData.enabledPayments.count) {
//                 for (int x=0; x<response.transactionData.enabledPayments.count; x++) {
//                     for (int i = 0; i<self.paymentList.count; i++) {
//                         MidtransPaymentListModel *paymentmodel= [[MidtransPaymentListModel alloc]initWithDictionary:self.paymentList[i]];
//                         if ([self.paymentRequestResponse.transactionData.enabledPayments[x] isEqualToString:paymentmodel.localPaymentIdentifier]) {
//                             [self.paymentMethodList addObject:paymentmodel];
//                         }
//                     }
//                 }
//             }
//             [self.tableView reloadData];
//             
//         }
//         else {
//             //todo what should happens when payment request is failed;
//         }
//     }];
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
    return self.paymentMethodList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransPaymentListModel *paymentMethod = self.paymentMethodList[indexPath.row];
    SamplePaymentListTableViewCell *cell = (SamplePaymentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SamplePaymentListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SamplePaymentListTableViewCell" owner:self options:nil] firstObject];
        [tableView registerNib:[UINib nibWithNibName:@"SamplePaymentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SamplePaymentListTableViewCell"];
    }
    [cell configurePaymetnList:paymentMethod];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransPaymentListModel *paymentMethod = (MidtransPaymentListModel *)[self.paymentMethodList objectAtIndex:indexPath.row];
    
    if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
        PaymentCreditCardViewController *paymentCC = [[PaymentCreditCardViewController alloc] initWithNibName:@"PaymentCreditCardViewController" bundle:nil];
        paymentCC.transactionToken = self.transactionToken;
        [self.navigationController pushViewController:paymentCC animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_VA]) {
        BankTransferViewController *vc = [[BankTransferViewController alloc] initWithNibName:@"BankTransferViewController" bundle:nil];
        vc.transactionToken = self.transactionToken;
        vc.bankList = self.paymentRequestResponse.transactionData.bankTransfer;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_XL_TUNAI])
    {
        EpaymentViewController *vc = [[EpaymentViewController alloc] initWithNibName:@"EpaymentViewController" bundle:nil];
        vc.transactionToken = self.transactionToken;
        vc.paymentMethod = paymentMethod;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOSAT_DOMPETKU] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
        //        VTPaymentDirectViewController *vc = [[VTPaymentDirectViewController alloc] initWithToken:self.token
        //                                                                               paymentMethodName:paymentMethod];
        //        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_CLICKPAY]) {
        //        VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithToken:self.token
        //                                                                           paymentMethodName:paymentMethod];
        //        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
 
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
