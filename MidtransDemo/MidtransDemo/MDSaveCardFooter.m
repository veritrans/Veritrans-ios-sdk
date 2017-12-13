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

    
}

- (UIImage *)templateImageNamed:(NSString *)imageName {
    return [[UIImage imageNamed:imageName inBundle:nil compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
