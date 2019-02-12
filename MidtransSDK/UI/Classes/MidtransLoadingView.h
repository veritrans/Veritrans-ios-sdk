//
//  MidtransLoadingView.h
//  MidtransKit
//
//  Created by Arie on 10/27/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MidtransLoadingView : UIView

- (void)hide;
- (void)showInView:(UIView *)view withText:(NSString *)text;
@end
