//
//  MidtransTransactionDetailViewController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 12/28/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface MidtransTransactionDetailViewController : UIViewController
- (void)presentAtPositionOfView:(UIView *)view items:(NSArray *)items;
- (void)presentAtPositionOfView:(UIView *)view items:(NSArray *)items
         withChangedGrossAmount:(NSString *)grossAmount
                      pointName:(NSString *)pointName pointValue:(NSInteger)pointValue;
@end
