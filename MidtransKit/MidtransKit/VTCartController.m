//
//  VTCartController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCartController.h"
#import "VTCartCell.h"
#import "VTClassHelper.h"
#import "VTPaymentListController.h"

#import <MidtransCoreKit/VTHelper.h>

@interface VTCartController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic, readwrite) VTUser *user;
@property (nonatomic, readwrite) NSArray *items;
@end

@implementation VTCartController

+ (instancetype)cartWithUser:(VTUser *)user andItems:(NSArray *)items {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTCartController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTCartController"];
    vc.items = items;
    vc.user = user;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _totalAmountLabel.text = [VTItemViewModel totalPriceOfItems:_items];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payPressed:(UIButton *)sender {
    VTPaymentListController *vc = [VTPaymentListController controllerWithUser:_user items:_items];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)optionPressed:(UIBarButtonItem *)sender {
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTCartCell"];
    cell.item = _items[indexPath.row];
    return cell;
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
