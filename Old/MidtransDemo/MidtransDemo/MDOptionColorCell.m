//
//  MDOptionColorCell.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/24/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionColorCell.h"
#import "MDOptionManager.h"
#import "MDUtils.h"

@interface MDOptionColorCell()
@property (strong, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation MDOptionColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.colorImageView.layer.cornerRadius = 4;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.checkImageView.tintColor = [UIColor mdThemeColor];
    defaults_observe_object(@"md_color", ^(NSNotification *note) {
        self.checkImageView.tintColor = [UIColor mdThemeColor];
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkImageView.hidden = !selected;
}

@end
