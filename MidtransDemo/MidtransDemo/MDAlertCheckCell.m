//
//  MDAlertCheckCell.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 5/4/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDAlertCheckCell.h"

@interface MDAlertCheckCell()
@property (nonatomic) IBOutlet UIImageView *checkView;
@end

@implementation MDAlertCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.checkView.image = selected? [UIImage imageNamed:@"check_on"]: [UIImage imageNamed:@"check_off"];
}

@end
