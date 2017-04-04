//
//  MidtransLoadingView.h
//  MidtransKit
//
//  Created by Arie on 10/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransLoadingView : UIView
@property (weak, nonatomic) IBOutlet UILabel *loadingTitleLabel;
- (void)show;
- (void)showWithTitle:(NSString *)title;
- (void)hide;
- (void)remove;
- (void)showInView:(UIView *)view withText:(NSString *)text;
@end
