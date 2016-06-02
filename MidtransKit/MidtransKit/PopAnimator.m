//
//  PopAnimator.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "PopAnimator.h"
#import "VTCardListController.h"
#import "VTTwoClickController.h"
#import "VTCCBackView.h"
#import "VTCCFrontView.h"

@implementation PopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    VTCardListController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.layer.zPosition = -1000;
    VTTwoClickController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.view.layer.zPosition = -500;
    
    UIView *containerView = [transitionContext containerView];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect cardFrame = [window.rootViewController.view convertRect:fromViewController.backView.frame fromView:fromViewController.backView.superview];
    
    VTCCBackView *backView = [[VTCCBackView alloc] initWithFrame:cardFrame];
    VTCCFrontView *frontView = [[VTCCFrontView alloc] initWithFrame:cardFrame];
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:frontView];
    [containerView addSubview:backView];
    
    toViewController.collectionView.hidden = YES;
    fromViewController.backView.hidden = YES;
    
    CATransform3D rotateTransform = CATransform3DIdentity;
    rotateTransform.m34 = 1.0/-500.0;
    
    frontView.layer.transform = CATransform3DRotate(rotateTransform, M_PI_2, 0, 1, 0);
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
            fromViewController.view.alpha = 0.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            backView.layer.transform = CATransform3DRotate(rotateTransform, -M_PI_2, 0, 1, 0);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            frontView.layer.transform = CATransform3DRotate(rotateTransform, 0, 0, 1, 0);
        }];
        
    } completion:^(BOOL finished) {
        
        toViewController.collectionView.hidden = NO;
        fromViewController.backView.hidden = NO;
        
        [backView removeFromSuperview];
        [frontView removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

