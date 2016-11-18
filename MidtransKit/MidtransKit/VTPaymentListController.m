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
#import "MidtransUIPaymentDirectViewController.h"
#import "VTMandiriClickpayController.h"
#import "VTVAListController.h"
#import "VTAddCardController.h"
#import "MidtransUIPaymentListFooter.h"
#import "MidtransUIPaymentListHeader.h"
#import "VTPaymentListView.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "VTPaymentListDataSource.h"
#define DEFAULT_HEADER_HEIGHT 80;
#define SMALL_HEADER_HEIGHT 40;
@interface VTPaymentListController () <UITableViewDelegate, VTAddCardControllerDelegate>
@property (strong, nonatomic) IBOutlet VTPaymentListView *view;
@property (nonatomic,strong) NSMutableArray *paymentMethodList;
@property (nonatomic,strong) MidtransPaymentRequestV2Response *responsePayment;
@property (nonatomic,strong) VTPaymentListDataSource *dataSource;
@property (nonatomic)BOOL singlePayment;
@property (nonatomic) CGFloat tableHeaderHeight;
@end

@implementation VTPaymentListController;
@dynamic view;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableHeaderHeight = DEFAULT_HEADER_HEIGHT;
    self.title =  UILocalizedString(@"payment.list.title", nil);
    self.singlePayment = false;
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
     [self.view.loadingView showWithTitle:@"Loading payment list"];
    [[MidtransMerchantClient shared] requestPaymentlistWithToken:self.token.tokenId
                                                      completion:^(MidtransPaymentRequestV2Response * _Nullable response, NSError * _Nullable error)
     {
         self.title = response.merchant.preference.displayName;
         if (response) {
             self.responsePayment = response;
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
                  [self.view.loadingView hide];
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
                     if (response.enabledPayments.count>1) {
                         [self.view.tableView reloadData];
                     }
                     else {
                         self.singlePayment = YES;
                         [self redirectToPaymentMethodAtIndex:0];
                     }

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
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_CANCELED object:nil];
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
    [self redirectToPaymentMethodAtIndex:indexPath.row];
}
- (void)redirectToPaymentMethodAtIndex:(NSInteger)index {
    MidtransPaymentListModel *paymentMethod = (MidtransPaymentListModel *)[self.paymentMethodList objectAtIndex:index];
    [[MidtransTrackingManager shared] trackEventWithEvent:MIDTRANS_CORE_TRACKING_SELECT_PAYMENT withProperties:@{MIDTRANS_CORE_TRACKING_SELECT_PAYMENT_TYPE:paymentMethod.internalBaseClassIdentifier}];
    
    if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
        if ([CC_CONFIG paymentType] == VTCreditCardPaymentTypeNormal) {
            VTAddCardController *vc = [[VTAddCardController alloc] initWithToken:self.token
                                                               paymentMethodName:paymentMethod];
            [vc showDismissButton:self.singlePayment];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:!self.singlePayment];
        }
        else {
            VTCardListController *vc = [[VTCardListController alloc] initWithToken:self.token
                                                                 paymentMethodName:paymentMethod
                                                                 andCreditCardData:self.responsePayment.creditCard];
            [vc showDismissButton:self.singlePayment];
            [self.navigationController pushViewController:vc animated:!self.singlePayment];
        }
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_VA]) {
        VTVAListController *vc = [[VTVAListController alloc] initWithToken:self.token
                                                         paymentMethodName:paymentMethod];
        vc.paymentResponse = self.responsePayment;
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_XL_TUNAI])
    {
        MidtransUIPaymentGeneralViewController *vc = [[MidtransUIPaymentGeneralViewController alloc] initWithToken:self.token
                                                                                                 paymentMethodName:paymentMethod
                                                                                                          merchant:self.responsePayment.merchant];
          [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOSAT_DOMPETKU] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
        MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithToken:self.token
                                                                                               paymentMethodName:paymentMethod];
          [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_CLICKPAY]) {
        VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithToken:self.token
                                                                           paymentMethodName:paymentMethod];
          [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
    else {
        MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
          [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
}
#pragma mark - VTAddCardControllerDelegate
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
          [self.view.loadingView hide];
}
- (void)viewController:(VTAddCardController *)viewController didRegisterCard:(MidtransMaskedCreditCard *)registeredCard {
    
}

@end
