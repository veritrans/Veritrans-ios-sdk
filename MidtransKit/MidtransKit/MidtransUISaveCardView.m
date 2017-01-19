//
//  MidtransUISaveCardView.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/20/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransUISaveCardView.h"
#import "VTClassHelper.h"
@implementation MidtransUISaveCardView

- (void)setupView {
    UIView *view = [[VTBundle loadNibNamed:@"MidtransUISaveCardView" owner:self options:nil] firstObject];
    [self addSubview:view];
    [self setFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, 40)];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
@end
