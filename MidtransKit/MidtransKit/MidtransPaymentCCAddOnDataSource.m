//
//  MidtransPaymentCCAddOnDataSource.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/24/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransPaymentCCAddOnDataSource.h"
#import "VTClassHelper.h"
#import "AddOnConstructor.h"
#import "MidtransCreditCardAddOnComponentCell.h"
@interface MidtransPaymentCCAddOnDataSource()<MidtransCreditCardAddOnComponentCellDelegate>
@end;
@implementation MidtransPaymentCCAddOnDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.paymentAddOnArray = @[];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paymentAddOnArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddOnConstructor *paymnetAddOn = [self.paymentAddOnArray objectAtIndex:indexPath.row];
    MidtransCreditCardAddOnComponentCell *cell = (MidtransCreditCardAddOnComponentCell *)[tableView dequeueReusableCellWithIdentifier:@"MidtransCreditCardAddOnComponentCell"];
    cell.delegate = self;
    cell.addOnInformationButton.tag = indexPath.row;
    [cell configurePaymentAddOnWithData:paymnetAddOn];
    return cell;
}
- (void)informationButtonDidTappedWithTag:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(informationButtonDidTappedWithTag:)]) {
        [self.delegate informationButtonDidTappedWithTag:index];
    }
}
@end
