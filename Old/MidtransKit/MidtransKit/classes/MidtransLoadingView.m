//
//  MidtransLoadingView.m
//  MidtransKit
//
//  Created by Arie on 10/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransLoadingView.h"
#import "VTClassHelper.h"
#import "MidtransLoadingIndicator.h"

@interface MidtransLoadingView()
@property (nonatomic) IBOutlet UIImageView *indicatorLeft;
@property (nonatomic) IBOutlet UIImageView *indicatorMid;
@property (nonatomic) IBOutlet UIImageView *indicatorRight;
@property (nonatomic) IBOutlet UILabel *loadingTitleLabel;
@end;

@implementation MidtransLoadingView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.indicatorLeft.alpha = 0;
    self.indicatorMid.alpha = 0;
    self.indicatorRight.alpha = 0;
}

- (void)startAnimating {
    NSUInteger duration = 1.90;
    CGFloat frameCount = 6;
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:duration/frameCount animations:^{
            self.indicatorLeft.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:1/frameCount relativeDuration:duration/frameCount animations:^{
            self.indicatorMid.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:2/frameCount relativeDuration:duration/frameCount animations:^{
            self.indicatorRight.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:3/frameCount relativeDuration:duration/frameCount animations:^{
            self.indicatorLeft.alpha = 0;
        }];
        [UIView addKeyframeWithRelativeStartTime:4/frameCount relativeDuration:duration/frameCount animations:^{
            self.indicatorMid.alpha = 0;
        }];
        [UIView addKeyframeWithRelativeStartTime:5/frameCount relativeDuration:duration/frameCount animations:^{
            self.indicatorRight.alpha = 0;
        }];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)stopAnimating {
    [self.indicatorLeft.layer removeAllAnimations];
    [self.indicatorMid.layer removeAllAnimations];
    [self.indicatorRight.layer removeAllAnimations];
}

- (void)hide {
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self stopAnimating];
        [self.superview sendSubviewToBack:self];
    }];
}
- (void)showInView:(UIView *)view withText:(NSString *)text {
    self.alpha = 0;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[loading]-0-|" options:0 metrics:0 views:@{@"loading":self}]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[loading]-0-|" options:0 metrics:0 views:@{@"loading":self}]];
    
    self.loadingTitleLabel.text = text?text:@"Loading";
    
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self startAnimating];
    }];
}

@end
