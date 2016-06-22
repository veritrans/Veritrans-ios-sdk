//
//  VTPaymentGuideView.h
//  MidtransKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPaymentGuideView : UIView
@property (weak, nonatomic) IBOutlet UITextView *guideTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMenuGuideHeightConstraints;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@end
