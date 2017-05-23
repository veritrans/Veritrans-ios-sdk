//
//  MDSaveCardFooter.m
//  MidtransDemo
//
//  Created by Vanbungkring on 5/5/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDSaveCardFooter.h"
@implementation MDSaveCardFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.addCardButton setImage:[self templateImageNamed:@"plus-icon"] forState:UIControlStateNormal];
    UIEdgeInsets insets = self.addCardButton.titleEdgeInsets;
    insets.left = 8;
    self.addCardButton.titleEdgeInsets = insets;
    self.addCardButton.layer.borderWidth = 1.;
    self.addCardButton.layer.cornerRadius = 5.;
    
}

- (UIImage *)templateImageNamed:(NSString *)imageName {
    return [[UIImage imageNamed:imageName inBundle:nil compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
