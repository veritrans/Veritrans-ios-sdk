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

@interface VTVAListController ()
@property (nonatomic) MidtransCustomerDetails *customer;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *vaList;
@end

@implementation VTVAListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = UILocalizedString(@"va.list.title", nil);
 [[MIDTrackingManager shared] trackEventName:@"pg select atm transfer"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransUIListCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransUIListCell"];
    NSString *path = [VTBundle pathForResource:@"virtualAccount" ofType:@"plist"];
    NSMutableArray *vaListM = [NSMutableArray new];
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];

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
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_vaList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransUIListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MidtransUIListCell"];
    [cell configurePaymetnList:self.vaList[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransPaymentListModel *vaTypeModel = (MidtransPaymentListModel *)[self.vaList objectAtIndex:indexPath.row];
    NSString *paymentName  = vaTypeModel.shortName;
    [[MIDTrackingManager shared] trackEventName:paymentName];
    MidtransVAViewController *vc = [[MidtransVAViewController alloc] initWithToken:self.token paymentMethodName:vaTypeModel];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
