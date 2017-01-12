//
//  MidtransInstallmentCollectionViewCell.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/12/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransInstallmentCollectionViewCell.h"

@implementation MidtransInstallmentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureInstallmentWithText:(NSString *)title {
    if ([title isEqualToString:@"0"]) {
         self.installmentLabel.text =@"No Installment";
    }
    else {
    self.installmentLabel.text = [NSString stringWithFormat:@"%@ installments",title];
    }
}
@end
