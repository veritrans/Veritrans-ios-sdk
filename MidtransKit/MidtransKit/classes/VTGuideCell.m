//
//  VTGuideCell.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTGuideCell.h"
#import "VTClassHelper.h"

@interface VTGuideCell()
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *illustrationView;
@property (strong, nonatomic) IBOutlet VTTapableLabel *contentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *illustrationWidth;

@end

@implementation VTGuideCell

- (void)setInstruction:(VTInstruction *)instruction number:(NSInteger)number {
    self.numberLabel.text = [NSString stringWithFormat:@"%li", (long)number];
    self.contentLabel.tapableText = instruction.content;
    
    UIImage *image = [UIImage imageNamed:instruction.image inBundle:VTBundle compatibleWithTraitCollection:nil];
    if (image) {
        self.illustrationView.image = image;
        self.illustrationWidth.constant = image.size.width + 13;
    }
    else {
        self.illustrationView.image = nil;
        self.illustrationWidth.constant = 0;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
