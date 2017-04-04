//
//  MidtransInstallmentCollectionViewCell.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/12/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransInstallmentCollectionViewCell.h"
#import "VTClassHelper.h"
@implementation MidtransInstallmentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.94 green:0.97 blue:0.99 alpha:1.0];
    // Initialization code
}
- (void)configurePointWithThext:(NSNumber *)number {
    self.installmentLabel.text =[NSString stringWithFormat:@"%@",number.formattedCurrencyNumber];
}
- (void)configureInstallmentWithText:(NSString *)title {
    if ([title isEqualToString:@"0"]) {
         self.installmentLabel.text =@"No Installment";
    }
    else {
        self.installmentLabel.text = [NSString stringWithFormat:@"%@ Month installments",title];
    }
}
@end
