//
//  VTPaymentController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 5/11/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>

#import "VTErrorStatusController.h"
#import "VTPaymentStatusViewModel.h"
#import "VTSuccessStatusController.h"
@interface VTPaymentController : UIViewController
@property (nonatomic,strong) VTCustomerDetails *customerDetails;
@property (nonatomic,strong) NSArray *itemDetails;
@property (nonatomic,strong) VTPaymentListModel *paymentMethod;
@property (nonatomic) VTTransactionDetails *transactionDetails;

-(instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails
                           itemDetails:(NSArray <VTItemDetail*>*)itemDetails
                    transactionDetails:(VTTransactionDetails *)transactionDetails
                     paymentMethodName:(VTPaymentListModel *)paymentMethod;

-(void)addNavigationToTextFields:(NSArray <UITextField*>*)fields;
-(void)showLoadingHud;
-(void)hideLoadingHud;
-(void)handleTransactionError:(NSError *)error;
-(void)handleTransactionSuccess:(VTTransactionResult *)result;
-(void)showGuideViewControllerWithPaymentName:(NSString *)paymentName;
@end
