//
//  VTVAListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTVAListController.h"
#import "VTClassHelper.h"
#import "VTListCell.h"
#import "VTVAController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface VTVAListController ()
@property (nonatomic) VTCustomerDetails *customer;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *vaList;
@end

@implementation VTVAListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    [_tableView registerNib:[UINib nibWithNibName:@"VTListCell" bundle:VTBundle] forCellReuseIdentifier:@"VTListCell"];
    
    NSString *path = [VTBundle pathForResource:@"virtualAccount" ofType:@"plist"];
    NSMutableArray *vaListM = [NSMutableArray new];
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];
    for (int i = 0; i<paymentList.count; i++) {
        VTPaymentListModel *paymentmodel= [[VTPaymentListModel alloc]initWithDictionary:paymentList[i]];
        [vaListM addObject:paymentmodel];
    }
    _vaList = vaListM;
    
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    _totalAmountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_vaList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTListCell"];
    [cell configurePaymetnList:_vaList[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VTPaymentListModel *vaTypeModel = (VTPaymentListModel *)[_vaList objectAtIndex:indexPath.row];
    VTVAType vaType;
    
    if ([vaTypeModel.internalBaseClassIdentifier isEqualToString:VT_VA_BCA_IDENTIFIER]) {
        vaType = VTVATypeBCA;
    } else if ([vaTypeModel.internalBaseClassIdentifier isEqualToString:VT_VA_MANDIRI_IDENTIFIER]) {
        vaType = VTVATypeMandiri;
    } else if ([vaTypeModel.internalBaseClassIdentifier isEqualToString:VT_VA_PERMATA_IDENTIFIER]) {
        vaType = VTVATypePermata;
    } else {
        vaType = VTVATypeOther;
    }
    
    VTVAController *vc = [[VTVAController alloc] initWithVAType:vaType
                                                customerDetails:self.customerDetails
                                                    itemDetails:self.itemDetails
                                             transactionDetails:self.transactionDetails];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
