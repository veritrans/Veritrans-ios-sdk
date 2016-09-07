//
//  VTPaymentListDataSource.m
//  MidtransKit
//
//  Created by Arie on 6/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentListDataSource.h"
#import "VTListCell.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransPaymentListModel.h>

@implementation VTPaymentListDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paymentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTPaymentListModel *paymentMethod = self.paymentList[indexPath.row];
    VTListCell *cell = (VTListCell *)[tableView dequeueReusableCellWithIdentifier:@"VTListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VTListCell" owner:self options:nil] firstObject];
        [tableView registerNib:[UINib nibWithNibName:@"VTListCell" bundle:VTBundle] forCellReuseIdentifier:@"VTListCell"];
    }
    [cell configurePaymetnList:paymentMethod];
    [cell updateConstraintsIfNeeded];
    [cell layoutIfNeeded];
    return cell;
}
@end
