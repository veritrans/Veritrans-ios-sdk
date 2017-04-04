//
//  MidtransSavedCardFooter.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/2/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransSavedCardFooter.h"
#import "MidtransUIThemeManager.h"
#import "VTClassHelper.h"

@implementation MidtransSavedCardFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *themeColor = [[MidtransUIThemeManager shared] themeColor];
    [self.addCardButton setImage:[self templateImageNamed:@"plus-icon"] forState:UIControlStateNormal];
    [self.addCardButton setTitleColor:themeColor forState:UIControlStateNormal];
    [self.addCardButton setTintColor:themeColor];
    UIEdgeInsets insets = self.addCardButton.titleEdgeInsets;
    insets.left = 8;
    self.addCardButton.titleEdgeInsets = insets;
    self.addCardButton.layer.borderColor = themeColor.CGColor;
    self.addCardButton.layer.borderWidth = 1.;
    self.addCardButton.layer.cornerRadius = 5.;
    
}

- (UIImage *)templateImageNamed:(NSString *)imageName {
    return [[UIImage imageNamed:imageName inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
