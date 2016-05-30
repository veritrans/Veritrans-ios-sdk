//
//  VTToast.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTXibView.h"

@interface VTToast : VTXibView

+ (void)createToast:(NSString *)toast duration:(NSTimeInterval)duration containerView:(UIView *)containerView;

@end
