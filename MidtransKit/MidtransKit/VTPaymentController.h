//
//  VTPaymentController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

#import "VTErrorStatusController.h"
#import "VTPaymentStatusViewModel.h"
#import "VTSuccessStatusController.h"

@interface VTPaymentController : VTViewController
@property (nonatomic,strong) TransactionTokenResponse *token;
@property (nonatomic,strong) VTPaymentListModel *paymentMethod;

-(instancetype)initWithToken:(TransactionTokenResponse *)token;
-(instancetype)initWithToken:(TransactionTokenResponse *)token
           paymentMethodName:(VTPaymentListModel *)paymentMethod;
-(void)addNavigationToTextFields:(NSArray <UITextField*>*)fields;
-(void)showLoadingHud;
-(void)hideLoadingHud;
- (void)showMerchantLogo:(BOOL)merchantLogo;
-(void)handleTransactionError:(NSError *)error;
-(void)handleTransactionSuccess:(VTTransactionResult *)result;
-(void)showGuideViewController;
-(void)showToastInviewWithMessage:(NSString *)message;
-(void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle;
@end
