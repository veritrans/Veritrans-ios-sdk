//
//  VTPaymentGeneralView.h
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPaymentGeneralView : UIView
@property (weak, nonatomic) IBOutlet UITextView *guideTextView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@end
