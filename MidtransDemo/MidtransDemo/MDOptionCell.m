//
//  MDOptionCell.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionCell.h"

@interface MDOptionCell()
@property (strong, nonatomic) IBOutlet UIImageView *checkImageView;
@end

@implementation MDOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.checkImageView.hidden = !selected;
}

@end
