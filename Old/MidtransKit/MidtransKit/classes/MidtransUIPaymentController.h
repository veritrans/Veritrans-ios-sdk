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
#import "VTPaymentStatusViewModel.h"
#import "VTPaymentStatusController.h"
#import "MidtransUIPaymentViewController.h"
@interface MidtransUIPaymentController : MidtransUIBaseViewController
@property (nonatomic,strong) MidtransTransactionTokenResponse *token;
@property (nonatomic,strong) MidtransPaymentListModel *paymentMethod;

-(instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
           paymentMethodName:(MidtransPaymentListModel *)paymentMethod;

-(void)showBackButton:(BOOL)show;
-(void)showDismissButton:(BOOL)show;
-(void)addNavigationToTextFields:(NSArray <UITextField*>*)fields;
-(void)showLoadingWithText:(NSString *)text;
-(void)showMaintainViewWithTtitle:(NSString*)title andContent:(NSString *)content andButtonTitle:(NSString *)buttonTitle;
-(void)hideMaintain;
-(void)hideLoading;
-(void)handleTransactionError:(NSError *)error;
-(void)handleTransactionSuccess:(MidtransTransactionResult *)result;
-(void)handleTransactionPending:(MidtransTransactionResult *)result;
-(void)handleTransactionResult:(MidtransTransactionResult *)result;
-(void)showGuideViewController;
-(void)showToastInviewWithMessage:(NSString *)message;
-(void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle;
- (void)handleSaveCardSuccess:(MidtransMaskedCreditCard *)result;
- (void)handleSaveCardError:(NSError *)error;
@end
