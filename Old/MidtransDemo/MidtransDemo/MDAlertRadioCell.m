//
//  MDAlertRadioCell.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 5/4/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDAlertRadioCell.h"

@interface MDAlertRadioCell()
@property (nonatomic) IBOutlet UIImageView *radioView;
@end

@implementation MDAlertRadioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.radioView.image = selected? [UIImage imageNamed:@"selection_on"]: [UIImage imageNamed:@"selection_off"];
}

@end
