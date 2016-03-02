//
//  VTPaymentListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentListController.h"
#import "VTClassHelper.h"
#import "VTPaymentCell.h"
#import "VTPaymentHeader.h"
#import "VTCardListController.h"
#import "VTClickpayController.h"
#import "VTVAController.h"

@interface VTPaymentListController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *headerAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *footerAmountLabel;
@property (nonatomic) NSNumber *amount;
@property (nonatomic) VTUser *user;
@end

@implementation VTPaymentListController {
    NSArray *_payments;
}

+ (instancetype)paymentListWithUser:(VTUser *)user andAmount:(NSNumber *)amount {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTPaymentListController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTPaymentListController"];
    vc.amount = amount;
    vc.user = user;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [VTBundle pathForResource:@"Payments" ofType:@"plist"];
    _payments = [NSArray arrayWithContentsOfFile:path];
    
    NSNumberFormatter *formatter = [NSNumberFormatter numberFormatterWith:@"vt.number"];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    _headerAmountLabel.text = [formatter stringFromNumber:_amount];
    _footerAmountLabel.text = [formatter stringFromNumber:_amount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_payments count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = _payments[section][@"items"];
    return [items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = _payments[indexPath.section][@"items"];
    
    VTPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTPaymentCell"];
    cell.paymentItem = items[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VTPaymentHeader *header = [tableView dequeueReusableCellWithIdentifier:@"VTPaymentHeader"];
    header.titleLabel.text = _payments[section][@"name"];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = _payments[indexPath.section][@"items"][indexPath.row];
    NSString *identifier = item[@"id"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    
    if ([identifier isEqualToString:VTPaymentBCAKlikpay]) {
        
    } else if ([identifier isEqualToString:VTPaymentBCAVA]) {
        
    } else if ([identifier isEqualToString:VTPaymentCIMBClicks]) {
        
    } else if ([identifier isEqualToString:VTPaymentCreditCard]) {
        
        VTCardListController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTCardListController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([identifier isEqualToString:VTPaymentIndomaret]) {
        
    } else if ([identifier isEqualToString:VTPaymentMandiriBillpay]) {
        
    } else if ([identifier isEqualToString:VTPaymentMandiriClickpay]) {
        
        VTClickpayController *vc = [VTClickpayController controllerWithUser:_user
                                                                  andAmount:_amount];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([identifier isEqualToString:VTPaymentMandiriECash]) {
        
    } else if ([identifier isEqualToString:VTPaymentPermataVA]) {
        
    } else if ([identifier isEqualToString:@"bt"]) {
        VTVAController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTVAController"];
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
