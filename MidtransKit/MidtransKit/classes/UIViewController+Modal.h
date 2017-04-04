//
//  UIViewController+Modal.h
//  Moco-iPad
//
//  Created by Nanang Rafsanjani on 5/1/15.
//  Copyright (c) 2015 Aksaramaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Modal)

- (void)setResizeWhenKeyboardShown:(BOOL)resize;
- (BOOL)resizeWhenKeyboardShown;

- (void)setModalSize:(CGSize)size;
- (CGSize)modalSize;

- (void)setTapBackgroundToClose:(BOOL)tapBackgroundToClose;
- (BOOL)tapBackgroundToClose;


- (void)dismissCustomViewController:(void(^)())completion;
- (void)presentCustomViewController:(UIViewController *)customViewController onViewController:(UIViewController *)presentingViewController completion:(void(^)())completion;
- (void)presentCustomViewController:(UIViewController *)customViewController completion:(void (^)())completion;

@end
