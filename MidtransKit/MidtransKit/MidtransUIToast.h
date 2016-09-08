//
//  MidtransUIToast.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIXibView.h"

@interface MidtransUIToast : MidtransUIXibView

+ (void)createToast:(NSString *)toast duration:(NSTimeInterval)duration containerView:(UIView *)containerView;

@end
