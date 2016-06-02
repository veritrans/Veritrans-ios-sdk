//
//  UIViewController+Modal.m
//  Moco-iPad
//
//  Created by Nanang Rafsanjani on 5/1/15.
//  Copyright (c) 2015 Aksaramaya. All rights reserved.
//

#import "UIViewController+Modal.h"
#import <objc/runtime.h>

@interface CacheController : NSObject
@property (nonatomic, strong) NSMutableArray *controllers;
@end

@implementation CacheController

+ (id)shared {
    static CacheController *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (id)init {
    if (self = [super init]) {
        _controllers = [NSMutableArray new];
    }
    return self;
}

@end

@implementation UIViewController (Modal)

- (void)setResizeWhenKeyboardShown:(BOOL)resize {
    objc_setAssociatedObject(self, @"resize_view", @(resize),  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)resizeWhenKeyboardShown {
    return [objc_getAssociatedObject(self, @"resize_view") boolValue];
}

- (CGSize)modalSize {
    return [objc_getAssociatedObject(self, @"modal_size") CGSizeValue];
}

- (void)setModalSize:(CGSize)size {
    objc_setAssociatedObject(self, @"modal_size", [NSValue valueWithCGSize:size],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tapBackgroundToClose {
    return [objc_getAssociatedObject(self, @"tap_close") boolValue];
}

- (void)setTapBackgroundToClose:(BOOL)tapBackgroundToClose {
    objc_setAssociatedObject(self, @"tap_close", @(tapBackgroundToClose),  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)defaultViewRect {
    CGRect superViewRect = self.view.superview.bounds;
    CGSize viewSize = self.modalSize;
    CGPoint viewPoint = CGPointMake(CGRectGetMidX(superViewRect)-(viewSize.width/2),
                                    CGRectGetMidY(superViewRect)-(viewSize.height/2));
    CGRect result = {viewPoint, viewSize};
    return result;
}

#pragma mark - Selector

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSTimeInterval duration;
    CGRect kbFrame;
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&kbFrame];
    
    UIView *rootView = self.parentViewController.view;
    kbFrame = [self.view.superview convertRect:kbFrame fromView:rootView];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect viewRect = [self defaultViewRect];
                         
                         CGFloat intersectHeight = CGRectGetHeight(CGRectIntersection(viewRect, kbFrame)) + 10;
                         
                         if (intersectHeight > 0) {
                             viewRect.origin.y -= intersectHeight;
                             
                             if (viewRect.origin.y < 10) {
                                 viewRect.size.height -= fabs(viewRect.origin.y) + 10;
                                 viewRect.origin.y = 10;
                             }
                         }
                         
                         self.view.frame = CGRectIntegral(viewRect);
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval duration;
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.view.frame = [self defaultViewRect];
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)closeModal:(id)sender {
    [self dismissCustomViewController:nil];
}

#pragma mark - Present View Controller

- (void)dismissCustomViewController:(void(^)())completion {
    id objectController = [self lastObjectController];
    
    UIViewController *viewController = objectController[@"view_controller"];
    UIView *dimmedView = objectController[@"dimmed_view"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:viewController name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:viewController name:UIKeyboardWillHideNotification object:nil];
    
    [self.view endEditing:YES];
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            viewController.view.transform = CGAffineTransformMakeScale(0.7, 0.1);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            viewController.view.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
            dimmedView.alpha = 0;
        }];
    } completion:^(BOOL finished) {
        [viewController.view removeFromSuperview];
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
        
        [self removeLastObjectController];
        
        if (completion) {
            completion();
        }
    }];
}

- (void)presentCustomViewController:(UIViewController *)customViewController completion:(void (^)())completion {
    self.modalSize = self.preferredContentSize;
    [self presentCustomViewController:customViewController onViewController:self completion:completion];
}

- (void)presentCustomViewController:(UIViewController *)customViewController onViewController:(UIViewController *)presentingViewController completion:(void(^)())completion {
    
    if (customViewController.resizeWhenKeyboardShown) {
        [[NSNotificationCenter defaultCenter] addObserver:customViewController selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:customViewController selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    
    CGSize modalSize = customViewController.modalSize;
    
    if (CGSizeEqualToSize(modalSize, CGSizeZero)) {
        modalSize = customViewController.view.frame.size;
    }
    
    CGFloat width = modalSize.width;
    CGFloat height = modalSize.height;
    if (width<10) {
        width = 340;
    }
    if (height<10) {
        height = 450;
    }
    modalSize = CGSizeMake(width, height);
    customViewController.modalSize = modalSize;
    
    customViewController.view.layer.cornerRadius = 5;
    customViewController.view.layer.masksToBounds = YES;
    
    UIView *dimmedView = [UIView new];
    dimmedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    dimmedView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [presentingViewController.view addSubview:dimmedView];
    [presentingViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dimm]|" options:0 metrics:0 views:@{@"dimm":dimmedView}]];
    [presentingViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dimm]|" options:0 metrics:0 views:@{@"dimm":dimmedView}]];
    
    if (customViewController.tapBackgroundToClose) {
        UITapGestureRecognizer *closeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeModal:)];
        [dimmedView addGestureRecognizer:closeGesture];
    }
    
    customViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|
    UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|
    UIViewAutoresizingFlexibleBottomMargin;
    
    CGRect rootRect = presentingViewController.view.bounds;
    CGSize viewSize = customViewController.modalSize;
    CGPoint viewPoint = CGPointMake(CGRectGetMidX(rootRect)-(viewSize.width/2), CGRectGetMidY(rootRect)-(viewSize.height/2));
    CGRect viewRect = {viewPoint, viewSize};
    customViewController.view.frame = CGRectIntegral(viewRect);
    
    [presentingViewController addChildViewController:customViewController];
    [customViewController didMoveToParentViewController:self];
    [presentingViewController.view addSubview:customViewController.view];
    
    [self saveObjectController:@{@"view_controller":customViewController, @"dimmed_view":dimmedView}];
    
    customViewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    dimmedView.alpha = 0;
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        customViewController.view.transform = CGAffineTransformMakeScale(1, 1);
        
        dimmedView.alpha = 1.;
        
    } completion:^(BOOL finished) {
        
        if (completion) {
            completion();
        }
    }];
}

- (id)lastObjectController {
    return [[[CacheController shared] controllers] lastObject];
}
- (void)saveObjectController:(id)objectController {
    [[[CacheController shared] controllers] addObject:objectController];
}
- (void)removeLastObjectController {
    [[[CacheController shared] controllers] removeLastObject];
}

@end
