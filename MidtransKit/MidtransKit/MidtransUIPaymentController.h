//
//  VTPaymentController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIBaseViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransPaymentListModel.h>
#import "VTErrorStatusController.h"
#import "VTPaymentStatusViewModel.h"
#import "VTSuccessStatusController.h"

@interface MidtransUIPaymentController : MidtransUIBaseViewController
@property (nonatomic,strong) MidtransTransactionTokenResponse *token;
@property (nonatomic,strong) MidtransPaymentListModel *paymentMethod;

-(instancetype)initWithToken:(MidtransTransactionTokenResponse *)token;
-(instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
           paymentMethodName:(MidtransPaymentListModel *)paymentMethod;

-(void)addNavigationToTextFields:(NSArray <UITextField*>*)fields;
-(void)showLoadingHud;
-(void)hideLoadingHud;
-(void)handleTransactionError:(NSError *)error;
-(void)handleTransactionSuccess:(MidtransTransactionResult *)result;
-(void)handleTransactionPending:(MidtransTransactionResult *)result;
-(void)showGuideViewController;
-(void)showToastInviewWithMessage:(NSString *)message;
-(void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle;
@end
