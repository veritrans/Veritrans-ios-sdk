//
//  VTGuideCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTGuideCell.h"
#import "VTLabel.h"
#import "VTRoundedLabel.h"

@interface VTGuideCell ()
@property (nonatomic) IBOutlet VTLabel *guideLabel;
@property (nonatomic) IBOutlet VTRoundedLabel *numberLabel;
@end

@implementation VTGuideCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGuide:(NSString *)guide {
    _guide = guide;
    _guideLabel.vtText = guide;
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    _numberLabel.text = [@(number) stringValue];
}

@end
