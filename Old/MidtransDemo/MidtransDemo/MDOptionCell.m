//
//  MDOptionCell.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionCell.h"
#import "MDUtils.h"

@interface MDOptionCell()
@property (strong, nonatomic) IBOutlet UIImageView *checkImageView;
@end

@implementation MDOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.checkImageView.tintColor = [UIColor mdThemeColor];
    defaults_observe_object(@"md_color", ^(NSNotification *note){
        self.checkImageView.tintColor = [UIColor mdThemeColor];
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.checkImageView.hidden = !selected;
}

@end
