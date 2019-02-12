//
//  PushAnimator.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "PushAnimator.h"
#import "VTTwoClickController.h"
#import "VTCardListController.h"
#import "MidtransUICCFrontView.h"
#import "VTCCBackView.h"

@implementation PushAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *container = [transitionContext containerView];
    
    VTTwoClickController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.layer.zPosition = -500;
    VTCardListController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.view.layer.zPosition = -1000;    
    
    toViewController.view.frame = fromViewController.view.frame;
    
    CGRect cardFrame = [fromViewController.navigationController.view convertRect:fromViewController.collectionView.frame
                                                                        fromView:fromViewController.view];
    VTCCBackView *backView = [[VTCCBackView alloc] initWithFrame:cardFrame];
    MidtransUICCFrontView *frontView = [[MidtransUICCFrontView alloc] initWithFrame:cardFrame
                                                                         maskedCard:fromViewController.selectedMaskedCard];
    
    
    [container addSubview:toViewController.view];
    [container addSubview:backView];
    [container addSubview:frontView];
    
    toViewController.backView.hidden = YES;
    fromViewController.collectionView.hidden = YES;
    
    CATransform3D rotateTransform = CATransform3DIdentity;
    rotateTransform.m34 = 1.0/-500.0;
    
    backView.layer.transform = CATransform3DRotate(rotateTransform, M_PI_2, 0, 1, 0);
    toViewController.view.alpha = 0;
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
            toViewController.view.alpha = 1.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            frontView.layer.transform = CATransform3DRotate(rotateTransform, -M_PI_2, 0, 1, 0);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            backView.layer.transform = CATransform3DRotate(rotateTransform, 0, 0, 1, 0);
        }];
        
    } completion:^(BOOL finished) {
        
        fromViewController.collectionView.hidden = NO;
        toViewController.backView.hidden = NO;
        
        [backView removeFromSuperview];
        [frontView removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
