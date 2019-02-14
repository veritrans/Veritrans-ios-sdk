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
#import "MIDVendorUI.h"
#import "MIDArrayHelper.h"

#import "MidtransSDK.h"

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

- (MIDPaymentInfo *)info {
    return [MIDVendorUI shared].info;
}

- (NSString *)orderID {
    return self.info.transaction.orderID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalAmountTextLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    self.title = [VTClassHelper getTranslationFromAppBundleForString:@"va.list.title"];
    if (self.orderID) {
        [[SNPUITrackingManager shared] trackEventName:@"pg select atm transfer" additionalParameters:@{@"order id": self.orderID}];
    } else {
        [[SNPUITrackingManager shared] trackEventName:@"pg select atm transfer"];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransUIListCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransUIListCell"];
    
    NSArray *details = [self loadPaymentMethodDetails];
    
    NSArray *payments = [self.info.enabledPayments filter:^BOOL(MIDPaymentMethodInfo *obj) {
        return obj.category == MIDPaymentCategoryBankTransfer;
    }];
    
    //map to payment list model
    NSMutableArray *models = [NSMutableArray new];
    [payments enumerateObjectsUsingBlock:^(MIDPaymentMethodInfo * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [details indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj[@"id"] isEqualToString:[NSString stringFromPaymentMethod:info.type]];
        }];
        if (index != NSNotFound) {
            [models addObject:[[MidtransPaymentListModel alloc] initWithDictionary:details[index]]];
        }
    }];
    
    self.vaList = models;
    
    self.tableView.tableFooterView = [UIView new];
    self.totalAmountLabel.text = self.info.items.formattedGrossAmount;
    self.orderIdLabel.text = self.orderID;
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

- (NSArray *)loadPaymentMethodDetails {
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", @"paymentMethods"];
    NSString *path = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (path == nil) {
        path = [VTBundle pathForResource:@"en_paymentMethods" ofType:@"plist"];
    }
    return [NSArray arrayWithContentsOfFile:path];
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
    [cell configureWithModel:self.vaList[indexPath.row] info:self.info];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self redirectToIndex:indexPath.row];
}

- (void)redirectToIndex:(NSInteger)index {
    MidtransPaymentListModel *vaTypeModel = (MidtransPaymentListModel *)[self.vaList objectAtIndex:index];
    NSString *paymentName  = vaTypeModel.shortName;
    if (self.orderID) {
        [[SNPUITrackingManager shared] trackEventName:paymentName additionalParameters:@{@"order id": self.orderID}];
    } else {
        [[SNPUITrackingManager shared] trackEventName:paymentName];
    }
    
    //    MidtransVAViewController *vc = [[MidtransVAViewController alloc] initWithToken:self.token paymentMethodName:vaTypeModel];
    //    vc.response = self.paymentResponse;
    //    if (self.vaList.count == 1) {
    //        [vc showDismissButton:YES];
    //    }
    //    [self.navigationController pushViewController:vc animated:YES];
}
@end
