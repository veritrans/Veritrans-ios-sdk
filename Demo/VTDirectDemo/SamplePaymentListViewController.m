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
@property (nonatomic, strong) MidtransPaymentRequestV2Response *paymentRequestResponse;
@property (nonatomic,strong)NSMutableArray *paymentMethodList;
@end

@implementation SamplePaymentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentMethodList = [[NSMutableArray alloc] initWithCapacity:2];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(dismissModalViewControllerAnimated:)];
    
    self.navigationItem.leftBarButtonItem = doneButton;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"paymentMethods" ofType:@"plist"];
    self.paymentList = [NSArray arrayWithContentsOfFile:path];
    
    [[MidtransMerchantClient shared] requestPaymentlistWithToken:self.transactionToken.tokenId
                                                      completion:^(MidtransPaymentRequestV2Response * _Nullable response, NSError * _Nullable error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.title = response.merchant.preference.displayName;
         
         if (response) {
             self.paymentRequestResponse = response;
             
             bool vaAlreadyAdded = 0;
             NSInteger mainIndex = 0;
             NSDictionary *vaDictionaryBuilder = @{@"description":@"Pay from ATM Bersama, Prima or Alto",
                                                   @"id":@"va",
                                                   @"identifier":@"va",
                                                   @"title":@"ATM/Bank Transfer"
                                                   };
             
             NSArray *paymentAvailable = response.enabledPayments;
             for (MidtransPaymentRequestV2EnabledPayments *enabledPayment in paymentAvailable) {
                 NSInteger index = [self.paymentList indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     return [obj[@"id"] isEqualToString:enabledPayment.type];
                 }];
                 if (index != NSNotFound) {
                     MidtransPaymentListModel *model;
                     if ([enabledPayment.category isEqualToString:@"bank_transfer"]) {
                         if (!vaAlreadyAdded) {
                             if (mainIndex!=0) {
                                 model = [[MidtransPaymentListModel alloc] initWithDictionary:vaDictionaryBuilder];
                                 [self.paymentMethodList insertObject:model atIndex:1];
                                 vaAlreadyAdded = YES;
                             }
                         }
                     }
                     else if([enabledPayment.type isEqualToString:@"credit_card"]) {
                         model = [[MidtransPaymentListModel alloc] initWithDictionary:self.paymentList[index]];
                         [self.paymentMethodList addObject:model];
                     }
                     mainIndex++;
                 }
             }
               [self.tableView reloadData];
         }
         else {
         }
     }];
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
