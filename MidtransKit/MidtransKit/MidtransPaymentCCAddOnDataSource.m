//
//  MidtransPaymentCCAddOnDataSource.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/24/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransPaymentCCAddOnDataSource.h"
#import "VTClassHelper.h"
#import "MidtransCreditCardAddOnComponentCell.h"
@implementation MidtransPaymentCCAddOnDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.paymentAddOnArray = @[];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransCreditCardAddOnComponentCell *cell = (MidtransCreditCardAddOnComponentCell *)[tableView dequeueReusableCellWithIdentifier:@"MidtransCreditCardAddOnComponentCell"];
    return cell;
}

@end
