//
//  MidtransTransactionDetailViewController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 12/28/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
@class AddOnConstructor;
@interface MidtransTransactionDetailViewController : UIViewController
- (void)presentAtPositionOfView:(UIView *)view items:(NSArray *)items;
- (void)presentAtPositionOfView:(UIView *)view items:(NSArray *)items
         withChangedGrossAmount:(NSString *)grossAmount
                      pointName:(NSString *)pointName pointValue:(NSInteger)pointValue;
- (void)presentAtPositionOfView:(UIView *)view items:(NSArray *)items WithPromoSelected:(AddOnConstructor *)MidtransPromo;
@end
