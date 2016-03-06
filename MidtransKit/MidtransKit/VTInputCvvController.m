//
//  VTInputCvvController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/4/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTInputCvvController.h"
#import "VTCardListController.h"
#import "VTTextField.h"
#import "VTClassHelper.h"
#import "VTCCBackView.h"
#import "VTCCFrontView.h"

@interface PopAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end

@implementation PopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    VTCardListController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.layer.zPosition = -1000;
    VTInputCvvController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
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

@interface VTInputCvvController () <UINavigationControllerDelegate>
@property (nonatomic) IBOutlet VTTextField *cvvTextField;
@property (strong, nonatomic) IBOutlet UIView *finishPaymentView;
@end

@implementation VTInputCvvController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cvvTextField.inputAccessoryView = _finishPaymentView;
    
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_cvvTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)CVVChanged:(UITextField *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPop)
        return [[PopAnimator alloc] init];
    
    return nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_cvvTextField]) {
        return [textField filterCvvNumber:string range:range];
    } else {
        return YES;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
