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

@interface VTVAListController ()
@property (nonatomic) VTCustomerDetails *customer;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation VTVAListController {
    NSArray *_banks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) 
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    [_tableView registerNib:[UINib nibWithNibName:@"VTListCell" bundle:VTBundle] forCellReuseIdentifier:@"VTListCell"];
    
    NSString *path = [VTBundle pathForResource:@"virtualAccount" ofType:@"plist"];
    _banks = [NSArray arrayWithContentsOfFile:path];
    
    NSNumberFormatter *formatter = [NSNumberFormatter indonesianCurrencyFormatter];
    _totalAmountLabel.text = [formatter stringFromNumber:self.transactionDetails.grossAmount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_banks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTListCell"];
    cell.item = _banks[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = _banks[indexPath.row][@"id"];
    VTVAType vaType;
    
    if ([identifier isEqualToString:VTBCAVAIdentifier]) {
        vaType = VTVATypeBCA;
    } else if ([identifier isEqualToString:VTMandiriVAIdentifier]) {
        vaType = VTVATypeMandiri;
    } else if ([identifier isEqualToString:VTPermataVAIdentifier]) {
        vaType = VTVATypePermata;
    } else {
        vaType = VTVATypeOther;
    }
    
    VTVAController *vc = [[VTVAController alloc] initWithVAType:vaType customerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
    [self.navigationController pushViewController:vc animated:YES];
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
