//
//  MDOptionComposerCell.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 4/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionComposerCell.h"
#import "MDUtils.h"

@interface MDOptionComposerCell()
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UIButton *editButton;
@property (nonatomic) IBOutlet UIImageView *checkView;
@end
@implementation MDOptionComposerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.checkView.tintColor = [UIColor mdThemeColor];
    defaults_observe_object(@"md_color", ^(NSNotification *note){
        self.checkView.tintColor = [UIColor mdThemeColor];
    });
    
    [self.editButton addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.checkView.hidden = !selected;
}

- (void)editPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(optionCell:didEditOption:)]) {
        [self.delegate optionCell:self didEditOption:self.option];
    }
}

- (void)setOption:(MDOption *)option {
    _option = option;
    
    if ([option.name isEqualToString:@"Disable"]) {
        self.titleLabel.text = option.name;
        self.editButton.hidden = YES;
    }
    else {
        if ([option.value length]) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", option.name, option.value];
            self.editButton.hidden = NO;
        }
        else {
            self.titleLabel.text = option.name;
            self.editButton.hidden = YES;
        }
    }
}

@end
