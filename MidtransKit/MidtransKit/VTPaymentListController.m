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
#define DEFAULT_HEADER_HEIGHT 80;
#define SMALL_HEADER_HEIGHT 40;
@interface VTPaymentListController () <UITableViewDelegate>
@property (strong, nonatomic) IBOutlet VTPaymentListView *view;
@property (nonatomic,strong) NSMutableArray *paymentMethodList;
@property (nonatomic,strong) VTPaymentListDataSource *dataSource;
@property (nonatomic) CGFloat tableHeaderHeight;
@end

@implementation VTPaymentListController;
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableHeaderHeight = DEFAULT_HEADER_HEIGHT;
    self.title =  UILocalizedString(@"payment.list.title", nil);
    if ([VTImageManager merchantLogo]!=nil) {
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:self.navigationController.navigationBar.frame];
        titleImage.image = [VTImageManager merchantLogo];
        titleImage.contentMode =UIViewContentModeScaleAspectFit;
        titleImage.layer.masksToBounds = YES;
        self.navigationItem.titleView = titleImage;
    }
    
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
    self.view.header.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.tableView.frame), self.tableHeaderHeight);
    self.view.footer.amountLabel.text = @"-";
    self.view.header.amountLabel.text = @"-";
    
    NSString *path = [VTBundle pathForResource:@"paymentMethods" ofType:@"plist"];
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];
    
    [self showLoadingHud];
    
    [[VTMerchantClient sharedClient] requestPaymentlistWithToken:self.token.tokenId
                                                      completion:^(PaymentRequestResponse * _Nullable response, NSError * _Nullable error)
     {
         self.title = response.merchantData.displayName;
         [self hideLoadingHud];
         if (response) {
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
         else {
             //todo what should happens when payment request is failed;
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.tableHeaderHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.view.header;
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
        if ([CC_CONFIG saveCard]) {
            VTCardListController *vc = [[VTCardListController alloc] initWithToken:self.token
                                                                 paymentMethodName:paymentMethod];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            VTAddCardController *vc = [[VTAddCardController alloc] initWithToken:self.token
                                                               paymentMethodName:paymentMethod];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_VA_IDENTIFIER]) {
        VTVAListController *vc = [[VTVAListController alloc] initWithToken:self.token
                                                         paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_CIMB_CLIKS_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_ECASH_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_BCA_KLIKPAY_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_EPAY_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_XL_TUNAI])
    {
        VTPaymentGeneralViewController *vc = [[VTPaymentGeneralViewController alloc] initWithToken:self.token
                                                                                 paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_INDOMARET_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_KLIK_BCA_IDENTIFIER] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_TELKOMSEL_CASH] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:VT_PAYMENT_INDOSAT_DOMPETKU]) {
        VTPaymentDirectViewController *vc = [[VTPaymentDirectViewController alloc] initWithToken:self.token
                                                                               paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:VT_MANDIRI_CLICKPAY_IDENTIFIER]) {
        VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithToken:self.token
                                                                           paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
