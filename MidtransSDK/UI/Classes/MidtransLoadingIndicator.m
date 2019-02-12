//
//  MidtransLoadingIndicator.m
//  MidtransKit
//
//  Created by Arie on 10/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransLoadingIndicator.h"
#import "MidtransUIThemeManager.h"

@interface MidtransLoadingIndicator ()
@property (strong, nonatomic) CALayer *loadingIndicator1;
@property (strong, nonatomic) CALayer *loadingIndicator2;
@property (strong, nonatomic) CALayer *loadingIndicator3;
@end
@implementation MidtransLoadingIndicator
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initLoadingIndicator];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLoadingIndicator];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initLoadingIndicator];
    }
    return self;
}

- (void)initLoadingIndicator {
    self.loadingIndicator1 = [[CALayer alloc] init];
    self.loadingIndicator1.backgroundColor = [[MidtransUIThemeManager shared] themeColor].CGColor;
    [self.layer addSublayer:self.loadingIndicator1];

    self.loadingIndicator2 = [[CALayer alloc] init];
    self.loadingIndicator2.backgroundColor = [[MidtransUIThemeManager shared] themeColor].CGColor;
    [self.layer addSublayer:self.loadingIndicator2];

    self.loadingIndicator3 = [[CALayer alloc] init];
    self.loadingIndicator3.backgroundColor = [[MidtransUIThemeManager shared] themeColor].CGColor;
    [self.layer addSublayer:self.loadingIndicator3];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat diameter = CGRectGetHeight(self.frame);
    self.loadingIndicator1.frame = CGRectMake(0, 0, diameter, diameter);
    self.loadingIndicator1.cornerRadius = diameter / 2.0f;
    self.loadingIndicator1.transform = CATransform3DMakeScale(0, 0, 0);

    self.loadingIndicator2.frame = CGRectMake(diameter + 5, 0, diameter, diameter);
    self.loadingIndicator2.cornerRadius = diameter / 2.0f;
    self.loadingIndicator2.transform = CATransform3DMakeScale(0, 0, 0);

    self.loadingIndicator3.frame = CGRectMake(2 * diameter + 10, 0, diameter, diameter);
    self.loadingIndicator3.cornerRadius = diameter / 2.0f;
    self.loadingIndicator3.transform = CATransform3DMakeScale(0, 0, 0);
}
- (void)startAnimating {

    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.fromValue = [NSNumber numberWithFloat:0.0f];
    animation1.toValue = [NSNumber numberWithFloat:1.0f];
    animation1.duration = 0.5f;
    animation1.autoreverses = YES;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.loadingIndicator1 addAnimation:animation1 forKey:@"scale"];

    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = [NSNumber numberWithFloat:0.0f];
    animation2.toValue = [NSNumber numberWithFloat:1.0f];
    animation2.duration = 0.5f;
    animation2.autoreverses = YES;
    animation2.beginTime = CACurrentMediaTime() + 0.3f;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.loadingIndicator2 addAnimation:animation2 forKey:@"scale"];

    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation3.fromValue = [NSNumber numberWithFloat:0.0f];
    animation3.toValue = [NSNumber numberWithFloat:1.0f];
    animation3.duration = 0.5f;
    animation3.autoreverses = YES;
    animation3.beginTime = CACurrentMediaTime() + 0.6f;
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.loadingIndicator3 addAnimation:animation3 forKey:@"scale"];

    [self performSelector:@selector(startAnimating) withObject:nil afterDelay:1.6f];
}

- (void)stopAnimating {
    [self.loadingIndicator1 removeAllAnimations];
    [self.loadingIndicator2 removeAllAnimations];
    [self.loadingIndicator3 removeAllAnimations];

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimating) object:nil];
}

@end
