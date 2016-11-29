//
//  VTInstallmentCollectionViewCell.m
//  MidtransKit
//
//  Created by Arie on 11/28/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTInstallmentCollectionViewCell.h"

@implementation VTInstallmentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.94 green:0.97 blue:0.99 alpha:1.00];
    // Initialization code
}
- (void)configureInstallment:(NSString *)installment {
        self.installmentTextLabel.text = [NSString stringWithFormat:@"%@ Months Installment",installment];
    if ([installment isEqualToString:@"0"]) {
        self.installmentTextLabel.text = @"No installment";
    }

}
@end
