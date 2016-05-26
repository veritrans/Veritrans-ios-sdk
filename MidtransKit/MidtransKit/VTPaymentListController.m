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
#import "VTClickpayController.h"
#import "VTVAController.h"
#import "VTClicksController.h"
#import "VTAddCardController.h"
#import "VTVAListController.h"

@interface VTPaymentListController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *headerAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *footerAmountLabel;

@end

@implementation VTPaymentListController {
    NSArray *_payments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    [_tableView registerNib:[UINib nibWithNibName:@"VTListCell" bundle:VTBundle] forCellReuseIdentifier:@"VTListCell"];
    
    NSString *path = [VTBundle pathForResource:@"paymentMethods" ofType:@"plist"];
    _payments = [NSArray arrayWithContentsOfFile:path];
    
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    _headerAmountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
    _footerAmountLabel.text = _headerAmountLabel.text;
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
