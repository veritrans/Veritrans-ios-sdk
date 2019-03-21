//
//  VTPaymentController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIBaseViewController.h"
#import "VTPaymentStatusController.h"
#import "MidtransSDK.h"

@interface MidtransUIPaymentController : MidtransUIBaseViewController

@property (nonatomic,strong) MIDPaymentDetail *paymentMethod;

-(instancetype)init;
- (instancetype)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod;

-(void)showBackButton:(BOOL)show;
-(void)showDismissButton:(BOOL)show;
-(void)addNavigationToTextFields:(NSArray <UITextField*>*)fields;
-(void)showLoadingWithText:(NSString *)text;
-(void)showMaintainViewWithTtitle:(NSString*)title andContent:(NSString *)content andButtonTitle:(NSString *)buttonTitle;
-(void)hideMaintain;
-(void)hideLoading;
-(void)handleTransactionError:(NSError *)error;
-(void)handleTransactionSuccess:(MIDPaymentResult *)result;
-(void)handleTransactionPending:(MIDPaymentResult *)result;
- (void)handleTransactionResult:(MIDPaymentResult *)result;
-(void)showGuideViewController;
-(void)showToastInviewWithMessage:(NSString *)message;
-(void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle;
//- (void)handleSaveCardSuccess:(MidtransMaskedCreditCard *)result;
- (void)handleSaveCardError:(NSError *)error;

- (MIDPaymentInfo *)info;
- (NSString *)snapToken;
@end
