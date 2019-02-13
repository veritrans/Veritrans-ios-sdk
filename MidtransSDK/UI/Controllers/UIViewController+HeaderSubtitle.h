//
//  UIViewController+HeaderSubtitle.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HeaderSubtitle)

//should be called on viewDidload method
- (void)setHeaderWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end
