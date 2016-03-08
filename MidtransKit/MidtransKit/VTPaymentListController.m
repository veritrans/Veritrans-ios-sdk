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

@property (nonatomic, readwrite) NSArray *items;
@property (nonatomic, readwrite) VTUser *user;

@end

@implementation VTPaymentListController {
    NSArray *_payments;
}

+ (instancetype)controllerWithUser:(VTUser *)user items:(NSArray *)items {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTPaymentListController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTPaymentListController"];
    vc.items = items;
    vc.user = user;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tableView registerNib:[UINib nibWithNibName:@"VTListCell" bundle:VTBundle] forCellReuseIdentifier:@"VTListCell"];
    
    NSString *path = [VTBundle pathForResource:@"payments" ofType:@"plist"];
    _payments = [NSArray arrayWithContentsOfFile:path];
    
    NSNumberFormatter *formatter = [NSNumberFormatter numberFormatterWith:@"vt.number"];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    _headerAmountLabel.text = [formatter stringFromNumber:[_items itemsPriceAmount]];
    _footerAmountLabel.text = _headerAmountLabel.text;
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
    
    VTListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTListCell"];
    cell.item = items[indexPath.row];
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
    
    if ([identifier isEqualToString:VTCreditCardIdentifier]) {
        NSArray *cards = [[NSUserDefaults standardUserDefaults] savedCards];
        if ([cards count]) {
            VTCardListController *vc = [VTCardListController controllerWithUser:_user items:_items];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VTAddCardController *vc = [VTAddCardController controllerWithUser:_user items:_items];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([identifier isEqualToString:VTBCAKlikpayIdentifier]) {
        
    }
    else if ([identifier isEqualToString:VTCIMBClicksIdentifier]) {
        VTClicksController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTClicksController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([identifier isEqualToString:VTBRIEpayIdentifier]) {
        
        
        
    }
    else if ([identifier isEqualToString:VTMandiriClickpayIdentifier]) {
        VTClickpayController *vc = [VTClickpayController controllerWithUser:_user items:_items];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([identifier isEqualToString:VTBBMIdentifier]) {
        
    }
    else if ([identifier isEqualToString:VTIndosatDompetkuIdentifier]) {
        
    }
    else if ([identifier isEqualToString:VTMandiriECashIdentifier]) {
        
    }
    else if ([identifier isEqualToString:VTTCashIdentifier]) {
        
    }
    else if ([identifier isEqualToString:VTXLTunaiIdentifier]) {
        
    }
    else if ([identifier isEqualToString:VTVAIdentifier]) {
        VTVAListController *vc = [VTVAListController controllerWithUser:_user items:_items];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([identifier isEqualToString:VTIndomaretIdentifier]) {
        
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
