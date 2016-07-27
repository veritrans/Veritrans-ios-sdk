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
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/VTPaymentListModel.h>
#import <MidtransCoreKit/PaymentRequestDataModels.h>
#import "VTPaymentListDataSource.h"

@interface VTPaymentListController () <UITableViewDelegate>
@property (strong, nonatomic) IBOutlet VTPaymentListView *view;
@property (nonatomic,strong) NSMutableArray *paymentMethodList;
@property (nonatomic,strong) VTPaymentListDataSource *dataSource;
@end

@implementation VTPaymentListController;
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =  UILocalizedString(@"payment.list.title", nil);
    
    NSString *path = [VTBundle pathForResource:@"paymentMethods" ofType:@"plist"];
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];
    
    self.dataSource = [[VTPaymentListDataSource alloc] init];
    self.view.tableView.dataSource = self.dataSource;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    [self.view.tableView registerNib:[UINib nibWithNibName:@"VTListCell" bundle:VTBundle] forCellReuseIdentifier:@"VTListCell"];
    
    
    self.paymentMethodList = [NSMutableArray new];
    self.view.footer = [[VTPaymentListFooter alloc] initWithFrame:CGRectZero];
    self.view.footer.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.view.header = [[VTPaymentListHeader alloc] initWithFrame:CGRectZero];
    self.view.header.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.view.footer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.tableView.frame), 45);
    self.view.tableView.tableFooterView = self.view.footer;
    self.view.header.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.tableView.frame), 80);
    self.view.tableView.tableHeaderView = self.view.header;
    self.view.footer.amountLabel.text = @"-";
    self.view.header.amountLabel.text = @"-";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showLoadingHud];
        [[VTMerchantClient sharedClient] generateSnapTokenWithTransactionDetails:self.transactionDetails
                                                                     itemDetails:self.itemDetails
                                                                 customerDetails:self.customerDetails
                                                         customerCreditCardToken:nil
                                                                      completion:^(SnapTokenResponse * _Nullable token, NSError * _Nullable error) {
                                                                          if (!error) {
                                                                              [[VTMerchantClient sharedClient] requestPaymentlistWithToken:token.tokenId
                                                                                                                                completion:^(PaymentRequestResponse * _Nullable response, NSError * _Nullable error) {
                                                                                                                                    [self hideLoadingHud];
                                                                                                                                    if (!error) {
                                                                                                                                        NSInteger grandTotalAmount = [response.transactionData.transactionDetails.amount integerValue];
                                                                                                                                        self.view.footer.amountLabel.text = [NSNumber numberWithInteger:grandTotalAmount].formattedCurrencyNumber;
                                                                                                                                        self.view.header.amountLabel.text = [NSNumber numberWithInteger:grandTotalAmount].formattedCurrencyNumber;
                                                                                                                                        
                                                                                                                                        if (response.transactionData.enabledPayments.count) {
                                                                                                                                            for (int x=0; x<response.transactionData.enabledPayments.count; x++) {
                                                                                                                                                for (int i = 0; i<paymentList.count; i++) {
                                                                                                                                                    VTPaymentListModel *paymentmodel= [[VTPaymentListModel alloc]initWithDictionary:paymentList[i]];
                                                                                                                                                    if ([response.transactionData.enabledPayments[x] isEqualToString:paymentmodel.localPaymentIdentifier]) {
                                                                                                                                                        [self.paymentMethodList addObject:paymentmodel];
                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                        self.dataSource.paymentList = self.paymentMethodList;
                                                                                                                                        [self.view.tableView reloadData];
                                                                                                                                    }
                                                                                                                                }];
                                                                          }
                                                                          else {
                                                                              [self hideLoadingHud];
                                                                          }
                                                                      }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    VTPaymentListModel *paymentMethod = (VTPaymentListModel *)[self.paymentMethodList objectAtIndex:indexPath.row];
    if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_CREDIT_CARD_IDENTIFIER]) {
        VTCardListController *vc = [[VTCardListController alloc] initWithCustomerDetails:self.customerDetails
                                                                             itemDetails:self.itemDetails
                                                                      transactionDetails:self.transactionDetails
                                                                       paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_IDENTIFIER]) {
        VTVAListController *vc = [[VTVAListController alloc] initWithCustomerDetails:self.customerDetails
                                                                         itemDetails:self.itemDetails
                                                                  transactionDetails:self.transactionDetails
                                                                   paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_CIMB_CLIKS_IDENTIFIER] ||
               [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_ECASH_IDENTIFIER] ||
               [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_BCA_KLIKPAY_IDENTIFIER] ||
               [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_EPAY_IDENTIFIER]) {
        VTPaymentGeneralViewController *vc = [[VTPaymentGeneralViewController alloc] initWithCustomerDetails:self.customerDetails
                                                                                                 itemDetails:self.itemDetails
                                                                                          transactionDetails:self.transactionDetails
                                                                                           paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_INDOMARET_IDENTIFIER] ||
               [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_KLIK_BCA_IDENTIFIER]) {
        VTPaymentDirectViewController *vc = [[VTPaymentDirectViewController alloc] initWithCustomerDetails:self.customerDetails
                                                                                               itemDetails:self.itemDetails
                                                                                        transactionDetails:self.transactionDetails
                                                                                         paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_MANDIRI_CLICKPAY_IDENTIFIER]) {
        VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithCustomerDetails:self.customerDetails
                                                                                           itemDetails:self.itemDetails
                                                                                    transactionDetails:self.transactionDetails
                                                                                     paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


@end
