//
//  VTPaymentListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentListController.h"
#import "VTClassHelper.h"
#import "MidtransUIListCell.h"
#import "VTPaymentHeader.h"
#import "VTVAListController.h"
#import "VTMandiriClickpayController.h"
#import "MidtransUIPaymentGeneralViewController.h"
#import "MidtransUIPaymentDirectViewController.h"
#import "VTMandiriClickpayController.h"
#import "MidtransSavedCardController.h"
#import "VTPaymentListView.h"
#import "MidtransNewCreditCardViewController.h"
#import "MidtransPaymentGCIViewController.h"
#import "MidtransTransactionDetailViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransUIThemeManager.h"
#import "UIColor+SNP_HexString.h"

#define DEFAULT_HEADER_HEIGHT 80;
#define SMALL_HEADER_HEIGHT 40;

@interface VTPaymentListController () <UITableViewDelegate, VTPaymentListViewDelegate>
@property (strong, nonatomic) IBOutlet VTPaymentListView *view;
@property (nonatomic,strong) NSMutableArray *paymentMethodList;
@property (nonatomic,strong) MidtransPaymentRequestV2Response *responsePayment;
@property (nonatomic)BOOL singlePayment;
@property (nonatomic) CGFloat tableHeaderHeight;
@end

@implementation VTPaymentListController;

@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[MIDTrackingManager shared] trackEventName:@"pg select payment"];
    self.view.delegate = self;
    
    self.tableHeaderHeight = DEFAULT_HEADER_HEIGHT;
    self.title =  UILocalizedString(@"payment.list.title", nil);
    self.singlePayment = false;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    UIImage *logo = [MidtransImageManager merchantLogo];
    if (logo != nil) {
        UIView *titleViewWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:titleViewWrapper.frame];
        [imgView setImage:[MidtransImageManager merchantLogo]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        [titleViewWrapper addSubview:imgView];
        self.navigationItem.titleView = titleViewWrapper;
    }
    
    self.paymentMethodList = [NSMutableArray new];
    
    NSString *path = [VTBundle pathForResource:@"paymentMethods" ofType:@"plist"];
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];
    [self showLoadingWithText:@"Loading payment list"];
    
    [[MidtransMerchantClient shared] requestPaymentlistWithToken:self.token.tokenId
                                                      completion:^(MidtransPaymentRequestV2Response * _Nullable response, NSError * _Nullable error)
     {
         self.title = response.merchant.preference.displayName;
         if (response) {
             //applying SNAP color if any
             UIColor *snapColor = [self colorFromSnapScheme:response.merchant.preference.colorScheme];
             [MidtransUIThemeManager applySnapThemeColor:snapColor];
             [self reloadThemeColor];
             
             //handle payment list
             self.responsePayment = response;
             bool vaAlreadyAdded = 0;
             NSInteger mainIndex = 0;
             NSDictionary *vaDictionaryBuilder = @{@"description":@"Pay from ATM Bersama, Prima or Alto",
                                                   @"id":@"va",
                                                   @"identifier":@"va",
                                                   @"shortName":@"atm transfer",
                                                   @"title":@"ATM/Bank Transfer"
                                                   };
             
             NSArray *paymentAvailable = response.enabledPayments;
             if (self.paymentMethodSelected.length>0) {
                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type==%@",self.paymentMethodSelected];
                 NSArray *results = [response.enabledPayments filteredArrayUsingPredicate:predicate];
                 if (!results.count) {
                     self.view.emptyView.hidden = NO;
                     return ;
                 }
             }
             for (MidtransPaymentRequestV2EnabledPayments *enabledPayment in paymentAvailable) {
                 NSInteger index ;
                 if (self.paymentMethodSelected.length > 0) {
                     index = [paymentList indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         return [obj[@"id"] isEqualToString:self.paymentMethodSelected];
                     }];
                 }
                 else {
                     index = [paymentList indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         return [obj[@"id"] isEqualToString:enabledPayment.type];
                     }];
                 }
                 
                 if (index != NSNotFound) {
                     MidtransPaymentListModel *model;
                     if ([enabledPayment.category isEqualToString:@"bank_transfer"] || [enabledPayment.type isEqualToString:@"echannel"]) {
                         if (!vaAlreadyAdded) {
                             if (mainIndex!=0) {
                                 model = [[MidtransPaymentListModel alloc] initWithDictionary:vaDictionaryBuilder];
                                 self.paymentMethodList.count > 0 ? [self.paymentMethodList insertObject:model atIndex:1]:[self.paymentMethodList addObject:model];
                                 vaAlreadyAdded = YES;
                             }
                         }
                     }
                     
                     else {
                         
                         model = [[MidtransPaymentListModel alloc] initWithDictionary:paymentList[index]];
                         [self.paymentMethodList addObject:model];
                         
                     }
                     mainIndex++;
                 }
                 
                 if (response.enabledPayments.count) {
                     [self.view setPaymentMethods:self.paymentMethodList andItems:self.token.itemDetails];
                 }
                 else if(self.paymentMethodSelected.length> 0 || response.enabledPayments.count == 1) {
                     self.singlePayment = YES;
                     [self redirectToPaymentMethodAtIndex:0];
                 }
                 
             }
             if (self.paymentMethodSelected.length > 0) {
                 self.singlePayment = YES;
                 [self redirectToPaymentMethodAtIndex:0];
             }
         }
         else {
             NSDictionary *userInfo = @{TRANSACTION_ERROR_KEY:error};
             [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_FAILED object:nil userInfo:userInfo];
         }
         
         [self hideLoading];
     }];
}

- (void)closePressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_CANCELED object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadThemeColor {
    UIColor *color = [[MidtransUIThemeManager shared] themeColor];
    self.navigationController.navigationBar.tintColor = color;
    self.view.headerView.backgroundColor = color;
}

- (UIColor *)colorFromSnapScheme:(NSString *)scheme {
    NSString *path = [VTBundle pathForResource:@"snap_colors" ofType:@"plist"];
    NSDictionary *snapColors = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *hex = snapColors[scheme];
    if (hex) {
        return [UIColor colorWithSNP_HexString:hex];
    }
    else {
        return nil;
    }
}

#pragma mark - VTPaymentListViewDelegate

- (void)paymentListView:(VTPaymentListView *)view didSelectAtIndex:(NSUInteger)index {
    [self redirectToPaymentMethodAtIndex:index];
}

#pragma mark - Helper

- (void)redirectToPaymentMethodAtIndex:(NSInteger)index {
    
    MidtransPaymentListModel *paymentMethod = (MidtransPaymentListModel *)[self.paymentMethodList objectAtIndex:index];
    NSString *paymentMethodName = paymentMethod.shortName;
    [[MIDTrackingManager shared] trackEventName:[NSString stringWithFormat:@"pg %@",[paymentMethodName stringByReplacingOccurrencesOfString:@"_" withString:@" "]]];
    
    if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
        if ([CC_CONFIG paymentType] == MTCreditCardPaymentTypeNormal) {
            MidtransNewCreditCardViewController *creditCardVC  = [[MidtransNewCreditCardViewController alloc]
                                                                  initWithToken:self.token
                                                                  paymentMethodName:paymentMethod
                                                                  andCreditCardData:self.responsePayment.creditCard andCompleteResponseOfPayment:self.responsePayment];
            creditCardVC.promos = self.responsePayment.promos;
            [creditCardVC showDismissButton:self.singlePayment];
            [self.navigationController pushViewController:creditCardVC animated:!self.singlePayment];
        }
        else {
            if (self.responsePayment.creditCard.savedTokens.count) {
                MidtransSavedCardController *vc = [[MidtransSavedCardController alloc] initWithToken:self.token
                                                                     paymentMethodName:paymentMethod
                                                                     andCreditCardData:self.responsePayment.creditCard
                                                                     andCompleteResponseOfPayment:self.responsePayment];
                vc.promos = self.responsePayment.promos;
                [vc showDismissButton:self.singlePayment];
                [self.navigationController pushViewController:vc animated:!self.singlePayment];
                
            }
            else {
                MidtransNewCreditCardViewController *creditCardVC  = [[MidtransNewCreditCardViewController alloc]
                                                                      initWithToken:self.token
                                                                      paymentMethodName:paymentMethod
                                                                      andCreditCardData:self.responsePayment.creditCard andCompleteResponseOfPayment:self.responsePayment];
                creditCardVC.promos = self.responsePayment.promos;
                [creditCardVC showDismissButton:self.singlePayment];
                [self.navigationController pushViewController:creditCardVC animated:!self.singlePayment];
            }
        }
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_VA]) {
        VTVAListController *vc = [[VTVAListController alloc] initWithToken:self.token
                                                         paymentMethodName:paymentMethod];
        vc.paymentResponse = self.responsePayment;
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_XL_TUNAI])
    {
        MidtransUIPaymentGeneralViewController *vc = [[MidtransUIPaymentGeneralViewController alloc] initWithToken:self.token
                                                                                                 paymentMethodName:paymentMethod
                                                                                                          merchant:self.responsePayment.merchant];
        [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_TELKOMSEL_CASH] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOSAT_DOMPETKU] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KIOS_ON]) {
        MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithToken:self.token
                                                                                               paymentMethodName:paymentMethod];
        [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_GCI]) {
        MidtransPaymentGCIViewController *vc = [[MidtransPaymentGCIViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_CLICKPAY]) {
        VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithToken:self.token
                                                                           paymentMethodName:paymentMethod];
        [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
    else {
        MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
        [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
}

@end
