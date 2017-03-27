//
//  MDOptionColorCell.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/24/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionColorCell.h"

@interface MDOptionColorCell()
@property (strong, nonatomic) IBOutlet UIImageView *checkImageView;
@property (strong, nonatomic) IBOutlet UIView *colorImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation MDOptionColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.colorImageView.layer.cornerRadius = 4;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.checkImageView.hidden = !selected;
}

- (void)setColorString:(NSString *)colorString {
    self.titleLabel.text = colorString;
    if ([colorString isEqualToString:@"Red"]) {
        self.colorImageView.backgroundColor = [UIColor redColor];
    }
    else if ([colorString isEqualToString:@"Green"]) {
        self.colorImageView.backgroundColor = [UIColor greenColor];
    }
    else if ([colorString isEqualToString:@"Orange"]) {
        self.colorImageView.backgroundColor = [UIColor orangeColor];
    }
    else if ([colorString isEqualToString:@"Black"]) {
        self.colorImageView.backgroundColor = [UIColor blackColor];
    }
    else {
        self.colorImageView.backgroundColor = [UIColor blueColor];
    }
}

@end
