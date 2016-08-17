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
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *illustrationWidth;

@end

@implementation VTGuideCell

- (NSAttributedString *)attributedString:(NSString *)string {
    NSDictionary *attribute = @{NSFontAttributeName:self.contentLabel.font,
                                NSForegroundColorAttributeName:self.contentLabel.textColor};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attribute];
    [attributedString replaceCharacterString:@"[token_button]" withIcon:[UIImage imageNamed:@"TokenButtonIcon" inBundle:VTBundle compatibleWithTraitCollection:nil]];
    return attributedString;
}

- (void)setInstruction:(VTInstruction *)instruction number:(NSInteger)number {
    self.numberLabel.text = [NSString stringWithFormat:@"%li", (long)number];
    self.contentLabel.attributedText = [self attributedString:instruction.content];
    
    UIImage *image = [UIImage imageNamed:instruction.image inBundle:VTBundle compatibleWithTraitCollection:nil];
    if (image) {
        self.illustrationView.image = image;
        self.illustrationWidth.constant = image.size.width + 13;
    }
    else {
        self.illustrationView.image = nil;
        self.illustrationWidth.constant = 0;
    }
}

@end
