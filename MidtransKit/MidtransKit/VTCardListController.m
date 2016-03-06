//
//  VTCardListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCardListController.h"
#import <MidtransCoreKit/VTItem.h>
#import <MidtransCoreKit/VTConfig.h>
#import <MidtransCoreKit/VTCPaymentCreditCard.h>

#import "VTClassHelper.h"
#import "VTAddCardController.h"
#import "VTInputCvvController.h"
#import "VTTextField.h"
#import "VTCCBackView.h"
#import "VTCCFrontView.h"

@interface PushAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@end

@implementation PushAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *container = [transitionContext containerView];
    
    VTInputCvvController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.layer.zPosition = -500;
    VTCardListController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.view.layer.zPosition = -1000;
    
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect cardFrame = [window.rootViewController.view convertRect:fromViewController.collectionView.frame fromView:fromViewController.collectionView.superview];
    
    VTCCBackView *backView = [[VTCCBackView alloc] initWithFrame:cardFrame];
    VTCCFrontView *frontView = [[VTCCFrontView alloc] initWithFrame:cardFrame];
    
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

@interface VTCardListController () <VTCardCellDelegate, UINavigationControllerDelegate>
@property (nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *paymentView;

@property (nonatomic, readwrite) VTUser *user;
@property (nonatomic, readwrite) NSNumber *amount;
@end

@implementation VTCardListController

+ (instancetype)controllerWithUser:(VTUser *)user amount:(NSNumber *)amount {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTCardListController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTCardListController"];
    vc.user = user;
    vc.amount = amount;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cards = [[NSUserDefaults standardUserDefaults] savedCards];
    
    [_pageControl setNumberOfPages:[_cards count]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newCardPressed:(UITapGestureRecognizer *)sender {
    VTAddCardController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTAddCardController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_cards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VTCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VTCardCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.creditCard = nil;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([CONFIG creditCardFeature] == VTCreditCardFeatureOneClick) {
        
        id savedCard = _cards[indexPath.row];
        VTCPaymentCreditCard *payment = [[VTCPaymentCreditCard alloc] initWithUser:_user amount:_amount];
        [payment chargeWithSavedCard:savedCard cvv:nil callback:^(id response, NSError *error) {
            
        }];
        
    } else {
        VTInputCvvController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTInputCvvController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - VTCardCellDelegate

- (void)cardCellShouldRemoveCell:(VTCardCell *)cell {
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return [PushAnimator new];;
    }
    
    return nil;
}

#pragma MARK - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 200);
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
