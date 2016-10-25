//
//  VTPaymentListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentListController.h"
#import "VTClassHelper.h"
#import "MidtransUIListCell.h"
#import "VTPaymentHeader.h"
#import "VTCardListController.h"
#import "VTMandiriClickpayController.h"
#import "MidtransUIPaymentGeneralViewController.h"
#import "VTMandiriClickpayController.h"
#import "VTAddCardController.h"
#import "VTVAListController.h"
#import "MidtransUIPaymentListFooter.h"
#import "MidtransUIPaymentListHeader.h"
#import "MidtransUIPaymentDirectViewController.h"
#import "VTPaymentListView.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

#import "VTPaymentListDataSource.h"
#define DEFAULT_HEADER_HEIGHT 80;
#define SMALL_HEADER_HEIGHT 40;
@interface VTPaymentListController () <UITableViewDelegate,VTAddCardControllerDelegate>
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
    
    
    self.dataSource = [[VTPaymentListDataSource alloc] init];
    self.view.tableView.dataSource = self.dataSource;
    self.view.tableView.tableFooterView = [UIView new];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    [self.view.tableView registerNib:[UINib nibWithNibName:@"MidtransUIListCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransUIListCell"];
    
    UIImage *logo = [MidtransImageManager merchantLogo];
    if (logo != nil) {
        const CGFloat barHeight = 44;
        const CGFloat statusBarHeigt = 20;
        CGFloat factoredLogoWidth = logo.size.width * (barHeight / logo.size.height);
        
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                               statusBarHeigt,
                                                                               factoredLogoWidth,
                                                                               barHeight
                                                                               )];
        
        titleImage.image = [MidtransImageManager merchantLogo];
        titleImage.contentMode = UIViewContentModeScaleAspectFit;
        titleImage.layer.masksToBounds = YES;
        self.navigationItem.titleView = titleImage;
    }
    
    self.paymentMethodList = [NSMutableArray new];
    self.view.footer = [[MidtransUIPaymentListFooter alloc] initWithFrame:CGRectZero];
    self.view.footer.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.view.header = [[MidtransUIPaymentListHeader alloc] initWithFrame:CGRectZero];
    self.view.header.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.view.footer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.tableView.frame), 45);
    //self.view.tableView.tableFooterView = self.view.footer;
    self.view.header.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.tableView.frame), self.tableHeaderHeight);
    self.view.footer.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.header.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    
    NSString *path = [VTBundle pathForResource:@"paymentMethods" ofType:@"plist"];
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];
    
    [self showLoadingHud];
    
    [[MidtransMerchantClient sharedClient] requestPaymentlistWithToken:self.token.tokenId
                                                            completion:^(MidtransPaymentRequestV2Response * _Nullable response, NSError * _Nullable error)
     {
         self.title = response.merchant.preference.displayName;
         [self hideLoadingHud];
         if (response) {
             bool vaAlreadyAdded = 0;
             NSInteger mainIndex = 0;
             NSDictionary *vaDictionaryBuilder = @{@"description":@"Pay from ATM Bersama, Prima or Alto",
                                                   @"id":@"va",
                                                   @"identifier":@"va",
                                                   @"title":@"ATM/Bank Transfer"
                                                   };
             NSInteger grandTotalAmount = [response.transactionDetails.grossAmount integerValue];
             self.view.header.amountLabel.text = [NSNumber numberWithInteger:grandTotalAmount].formattedCurrencyNumber;
              NSArray *paymentAvailable = response.enabledPayments;
             for (MidtransPaymentRequestV2EnabledPayments *enabledPayment in paymentAvailable) {
                 NSInteger index = [paymentList indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
                                          else {
                                                model = [[MidtransPaymentListModel alloc] initWithDictionary:paymentList[index]];
                                              [self.paymentMethodList addObject:model];
                                          }
                     mainIndex++;
                                      }
                 self.dataSource.paymentList = self.paymentMethodList;
                     [self.view.tableView reloadData];
             }
         }
         else {
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
    MidtransPaymentListModel *paymentMethod = (MidtransPaymentListModel *)[self.paymentMethodList objectAtIndex:indexPath.row];
    
    if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
        if ([CC_CONFIG saveCard]) {
            VTCardListController *vc = [[VTCardListController alloc] initWithToken:self.token
                                                                 paymentMethodName:paymentMethod];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            VTAddCardController *vc = [[VTAddCardController alloc] initWithToken:self.token
                                                               paymentMethodName:paymentMethod];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_VA]) {
        VTVAListController *vc = [[VTVAListController alloc] initWithToken:self.token
                                                         paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_XL_TUNAI])
    {
        MidtransUIPaymentGeneralViewController *vc = [[MidtransUIPaymentGeneralViewController alloc] initWithToken:self.token
                                                                                                 paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOSAT_DOMPETKU] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
        MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithToken:self.token
                                                                                               paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_CLICKPAY]) {
        VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithToken:self.token
                                                                           paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }    
    else {
        MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)scanCardButtonDidTapped {
    
}
@end
