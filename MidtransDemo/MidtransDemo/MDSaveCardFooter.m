//
//  MDSaveCardFooter.m
//  MidtransDemo
//
//  Created by Vanbungkring on 5/5/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDSaveCardFooter.h"
#import <QuartzCore/QuartzCore.h>
@implementation MDSaveCardFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    UIEdgeInsets insets = self.addCardButton.titleEdgeInsets;
    insets.left = 8;
    self.addCardButton.titleEdgeInsets = insets;
    self.addCardButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addCardButton.layer.borderWidth = 1.;
    self.addCardButton.layer.cornerRadius = 5.;
    
    
}

- (UIImage *)templateImageNamed:(NSString *)imageName {
    return [[UIImage imageNamed:imageName inBundle:nil compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
