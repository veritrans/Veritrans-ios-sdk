//
//  VTVAListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MIDUobMenuController.h"
#import "VTClassHelper.h"
#import "MidtransUIListCell.h"
#import "MidtransUIPaymentDirectViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransVAViewController.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransTransactionDetailViewController.h"
#import "MidtransUIThemeManager.h"
#import "MidtransUIPaymentGeneralViewController.h"
#import "MIDUobViewController.h"
#import "MIDUobMenuContent.h"

@interface MIDUobMenuController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) MidtransCustomerDetails *customer;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (nonatomic) NSArray *uobOptionListTitle;
@property (nonatomic) NSArray *uobOptionListDescription;
@property (nonatomic) NSArray *uobSelectedOptionTitles;
@property (nonatomic) NSArray *uobSelectedOptions;
@property (nonatomic) MIDUobMenuContent *MenuContentApp;
@property (nonatomic) MIDUobMenuContent *MenuContentWeb;
@property (nonatomic) NSArray *optionImages;


@end

@implementation MIDUobMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalAmountTextLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    self.title = @"EZ Pay";
    
    self.MenuContentApp = [[MIDUobMenuContent alloc]initWithAppMenu];
    self.MenuContentWeb = [[MIDUobMenuContent alloc]initWithWebMenu];

    self.uobOptionListTitle = @[self.MenuContentApp.menuTitle, self.MenuContentWeb
    .menuTitle];
    self.uobOptionListDescription = @[self.MenuContentApp.menuDescription, self.MenuContentWeb.menuDescription];
    self.uobSelectedOptionTitles = @[self.MenuContentApp.selectedTitle, self.MenuContentWeb.selectedTitle];
    self.uobSelectedOptions = @[self.MenuContentApp.selectedOptions, self.MenuContentWeb.selectedOptions];
    self.optionImages = @[self.MenuContentApp.menuImage, self.MenuContentWeb.menuImage];

    if (self.paymentResponse.transactionDetails.orderId) {
        [[SNPUITrackingManager shared] trackEventName:@"pg select uob" additionalParameters:@{@"order id": self.paymentResponse.transactionDetails.orderId}];
    } else {
        [[SNPUITrackingManager shared] trackEventName:@"pg select uob"];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransUIListCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransUIListCell"];
    
    self.tableView.tableFooterView = [UIView new];
    self.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.orderIdLabel.text = self.token.transactionDetails.orderId;
    if (self.uobOptionListTitle.count == 1) {
        [self redirectToIndex:0];
    }
    [self.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.totalAmountBorderedView items:self.token.itemDetails grossAmount:self.token.transactionDetails.grossAmount];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.uobOptionListTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransUIListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MidtransUIListCell"];
    [cell configureUobOptionList:self.uobOptionListTitle[indexPath.row] withUobOptionDescription:self.uobOptionListDescription[indexPath.row] optionImage:self.optionImages[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self redirectToIndex:indexPath.row];
}
- (void)redirectToIndex:(NSInteger)index {
    MIDUobViewController *vc = [[MIDUobViewController alloc]initWithToken:self.token paymentMethodName:self.paymentMethod];
    [vc showDismissButton:NO];
    vc.uobSelectedOptionTitle = self.uobSelectedOptionTitles[index];
    vc.uobSelectedOption = self.uobSelectedOptions[index];
    [self.navigationController pushViewController:vc animated:YES];

}
@end
