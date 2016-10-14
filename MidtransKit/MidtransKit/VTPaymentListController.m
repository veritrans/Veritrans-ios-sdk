//
//  VTPaymentListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentListController.h"
#import "VTClassHelper.h"
#import "VTListCell.h"
#import "VTPaymentHeader.h"
#import "VTCardListController.h"
#import "VTMandiriClickpayController.h"
#import "VTPaymentGeneralViewController.h"
#import "VTMandiriClickpayController.h"
#import "VTAddCardController.h"
#import "VTVAListController.h"
#import "VTPaymentListFooter.h"
#import "VTPaymentListHeader.h"
#import "VTPaymentDirectViewController.h"
#import "VTPaymentListView.h"
#import "VTPaymentListDataSource.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTPaymentListController () <UITableViewDelegate>
@property (strong, nonatomic) IBOutlet VTPaymentListView *view;
@property (nonatomic,strong) NSMutableArray *paymentMethodListDefault;
@property (nonatomic,strong) VTPaymentListDataSource *dataSource;
@end

@implementation VTPaymentListController;
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =  UILocalizedString(@"payment.list.title", nil);
    
    self.dataSource = [[VTPaymentListDataSource alloc] init];
    self.view.tableView.dataSource = self.dataSource;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    [self.view.tableView registerNib:[UINib nibWithNibName:@"VTListCell" bundle:VTBundle] forCellReuseIdentifier:@"VTListCell"];

    NSString *path = [VTBundle pathForResource:@"paymentMethods" ofType:@"plist"];
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];
    self.paymentMethodListDefault = [NSMutableArray new];
    if (!self.paymentMethodList.count) {
        for (int i = 0; i<paymentList.count; i++) {
            VTPaymentListModel *paymentmodel= [[VTPaymentListModel alloc]initWithDictionary:paymentList[i]];
            [self.paymentMethodListDefault addObject:paymentmodel];
        }
        self.dataSource.paymentList = self.paymentMethodListDefault;
    }
    else {
            for (NSString *enabledPayment in self.paymentMethodList) {
                NSInteger index = [paymentList indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return [obj[@"id"] isEqualToString:enabledPayment];
                }];
                if (index != NSNotFound) {
                    VTPaymentListModel *model= [[VTPaymentListModel alloc] initWithDictionary:paymentList[index]];
                    [self.paymentMethodListDefault addObject:model];
                    self.dataSource.paymentList = self.paymentMethodListDefault;
                }
            }
           self.dataSource.paymentList = self.paymentMethodListDefault;
    }

    //self.view.footer = [[VTPaymentListFooter alloc] initWithFrame:CGRectZero];
    //self.view.footer.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.view.header = [[VTPaymentListHeader alloc] initWithFrame:CGRectZero];
    self.view.header.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //self.view.footer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.tableView.frame), 45);
    self.view.tableView.tableFooterView = self.view.footer;
    self.view.header.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.tableView.frame), 80);
    self.view.tableView.tableHeaderView = self.view.header;
    
    //self.view.footer.amountLabel.text = self.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.header.amountLabel.text = self.transactionDetails.grossAmount.formattedCurrencyNumber;
    [self.view.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        UITableViewCell *cell = (UITableViewCell *) [self.dataSource tableView:self.view.tableView cellForRowAtIndexPath:indexPath];
        [cell updateConstraintsIfNeeded];
        [cell layoutIfNeeded];
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        UITableViewCell *cell = (UITableViewCell *) [self.dataSource tableView:self.view.tableView cellForRowAtIndexPath :indexPath];
        [cell updateConstraintsIfNeeded];
        [cell layoutIfNeeded];
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VTPaymentListModel *paymentMethod = (VTPaymentListModel *)[self.paymentMethodListDefault objectAtIndex:indexPath.row];
    if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_CREDIT_CARD_IDENTIFIER]) {
        if ([CONFIG merchantClientData]) {
            VTCardListController *vc = [[VTCardListController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails paymentMethodName:paymentMethod];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            VTAddCardController *vc = [[VTAddCardController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails paymentMethodName:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_IDENTIFIER]) {
        VTVAListController *vc = [[VTVAListController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_CIMB_CLIKS_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_ECASH_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_BCA_KLIKPAY_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_EPAY_IDENTIFIER]) {
        VTPaymentGeneralViewController *vc = [[VTPaymentGeneralViewController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_INDOMARET_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_KLIK_BCA_IDENTIFIER]) {
        VTPaymentDirectViewController *vc = [[VTPaymentDirectViewController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_MANDIRI_CLICKPAY_IDENTIFIER]) {
        VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


@end
