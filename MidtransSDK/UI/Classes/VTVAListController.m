//
//  VTVAListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVAListController.h"
#import "VTClassHelper.h"
#import "MidtransUIListCell.h"
#import "MidtransUIPaymentDirectViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransVAViewController.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransTransactionDetailViewController.h"
#import "MidtransUIThemeManager.h"

@interface VTVAListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) MidtransCustomerDetails *customer;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (nonatomic) NSArray *vaList;
@end

@implementation VTVAListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalAmountTextLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    self.title = [VTClassHelper getTranslationFromAppBundleForString:@"va.list.title"];
    if (self.paymentResponse.transactionDetails.orderId) {
        [[SNPUITrackingManager shared] trackEventName:@"pg select atm transfer" additionalParameters:@{@"order id": self.paymentResponse.transactionDetails.orderId}];
    } else {
        [[SNPUITrackingManager shared] trackEventName:@"pg select atm transfer"];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransUIListCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransUIListCell"];
    NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", @"virtualAccount"];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:@"en_virtualAccount" ofType:@"plist"];
    }
    
    NSMutableArray *vaListM = [NSMutableArray new];
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:guidePath];

    NSArray *paymentAvailable = self.paymentResponse.enabledPayments;
    for (MidtransPaymentRequestV2EnabledPayments *enabledPayment in paymentAvailable) {
        NSInteger index = [paymentList indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj[@"id"] isEqualToString:enabledPayment.type];
        }];
        if (index != NSNotFound) {
            if ([enabledPayment.category isEqualToString:@"bank_transfer"] || [enabledPayment.type isEqualToString:@"echannel"]) {
                 MidtransPaymentListModel *paymentmodel= [[MidtransPaymentListModel alloc]initWithDictionary:paymentList[index]];
                [vaListM addObject:paymentmodel];
            }
        }
    }

    self.vaList = vaListM;
    
    self.tableView.tableFooterView = [UIView new];
    self.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.orderIdLabel.text = self.token.transactionDetails.orderId;
    if (self.vaList.count == 1) {
        [self redirectToIndex:0];
    }
    [self.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.totalAmountBorderedView items:self.token.itemDetails];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vaList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransUIListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MidtransUIListCell"];
    [cell configurePaymetnList:self.vaList[indexPath.row] withFullPaymentResponse:self.paymentResponse];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self redirectToIndex:indexPath.row];
}
- (void)redirectToIndex:(NSInteger)index {
    MidtransPaymentListModel *vaTypeModel = (MidtransPaymentListModel *)[self.vaList objectAtIndex:index];
    NSString *paymentName  = vaTypeModel.shortName;
    if (self.paymentResponse.transactionDetails.orderId) {
        [[SNPUITrackingManager shared] trackEventName:paymentName additionalParameters:@{@"order id": self.paymentResponse.transactionDetails.orderId}];
    } else {
        [[SNPUITrackingManager shared] trackEventName:paymentName];
    }
    MidtransVAViewController *vc = [[MidtransVAViewController alloc] initWithToken:self.token paymentMethodName:vaTypeModel];
    vc.response = self.paymentResponse;
    if (self.vaList.count == 1) {
        [vc showDismissButton:YES];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end
