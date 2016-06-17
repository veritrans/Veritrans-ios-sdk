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
#import "VTVAController.h"
#import "VTCIMBClicksController.h"
#import "VTMandiriECashController.h"
#import "VTBCAKlikpayController.h"
#import "VTIndomaretController.h"
#import "VTKlikBCAViewController.h"
#import "VTMandiriClickpayController.h"
#import "VTAddCardController.h"
#import "VTVAListController.h"
#import "VTPaymentListFooter.h"
#import "VTPaymentListHeader.h"
#import "VTEpayBRIController.h"

@interface VTPaymentListController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) VTPaymentListFooter *footer;
@property (nonatomic) VTPaymentListHeader *header;
@end

@implementation VTPaymentListController {
    NSArray *_payments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title =  NSLocalizedString(@"Select Payment", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)  style:UIBarButtonItemStylePlain target:nil action:nil];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;

    _footer = [[VTPaymentListFooter alloc] initWithFrame:CGRectZero];
    _footer.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _header = [[VTPaymentListHeader alloc] initWithFrame:CGRectZero];
    _header.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [_tableView registerNib:[UINib nibWithNibName:@"VTListCell" bundle:VTBundle] forCellReuseIdentifier:@"VTListCell"];

    NSString *path = [VTBundle pathForResource:@"paymentMethods" ofType:@"plist"];
    _payments = [NSArray arrayWithContentsOfFile:path];

    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    _footer.amountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
    _header.amountLabel.text = _footer.amountLabel.text;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _footer.frame = CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 45);
    _tableView.tableFooterView = _footer;
    _header.frame = CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 80);
    _tableView.tableHeaderView = _header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_payments count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTListCell"];
    cell.item = _payments[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = _payments[indexPath.row][@"id"];

    if ([identifier isEqualToString:VTCreditCardIdentifier]) {
        VTCardListController *vc = [[VTCardListController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:VTVAIdentifier]) {
        VTVAListController *vc = [[VTVAListController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:VTClicksIdentifier]) {
        VTCIMBClicksController *vc = [[VTCIMBClicksController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:VTECashIdentifier]) {
        VTMandiriECashController *vc = [[VTMandiriECashController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:VTKlikpayIdentifier]) {
        VTBCAKlikpayController *vc = [[VTBCAKlikpayController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:VTKlikBCAIdentifier]) {
        VTKlikBCAViewController *vc = [[VTKlikBCAViewController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:VTIndomaretIdentifier]) {
        VTIndomaretController *vc = [[VTIndomaretController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:VTClickpayIdentifier]) {
        VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:VTEpayIdentifier]) {
        VTEpayBRIController *vc = [[VTEpayBRIController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
        [self.navigationController pushViewController:vc animated:YES];
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
