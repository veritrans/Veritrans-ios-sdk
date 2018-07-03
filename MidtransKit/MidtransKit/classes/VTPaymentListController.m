//
//  VTPaymentListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#import "VTPaymentListController.h"
#import "VTClassHelper.h"
#import "MidtransUIListCell.h"
#import "VTPaymentHeader.h"
#import "MidGopayViewController.h"
#import "VTVAListController.h"
#import "MidtransVAViewController.h"
#import "VTMandiriClickpayController.h"
#import "MidtransUIPaymentGeneralViewController.h"
#import "MidtransUIPaymentDirectViewController.h"
#import "VTMandiriClickpayController.h"
#import "MIDPaymentIndomaretViewController.h"
#import "MidtransSavedCardController.h"
#import "VTPaymentListView.h"
#import "MidtransNewCreditCardViewController.h"
#import "MidtransPaymentGCIViewController.h"
#import "MIDDanamonOnlineViewController.h"
#import "MidtransTransactionDetailViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransUIThemeManager.h"
#import "UIColor+SNP_HexString.h"

#define DEFAULT_HEADER_HEIGHT 80;
#define SMALL_HEADER_HEIGHT 40;

@interface VTPaymentListController () <UITableViewDelegate, VTPaymentListViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet VTPaymentListView *view;
@property (nonatomic,strong) NSMutableArray *paymentMethodList;
@property (nonatomic,strong) MidtransPaymentRequestV2Response *responsePayment;
@property (nonatomic)BOOL singlePayment;
@property (nonatomic) BOOL bankTransferOnly;
@property (nonatomic) CGFloat tableHeaderHeight;
@end

@implementation VTPaymentListController;

@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *additionalData = [NSMutableDictionary dictionaryWithDictionary:@{@"card mode":@"normal"}];
    if (self.responsePayment.transactionDetails.orderId) {
        [additionalData addEntriesFromDictionary:@{@"order id":self.responsePayment.transactionDetails.orderId}];
    }
    [[SNPUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:additionalData];
    self.view.delegate = self;
    if ([self.paymentMethodSelected isEqualToString:MIDTRANS_CREDIT_CARD_FORM]) {
        MidtransNewCreditCardViewController *creditCardVC  = [[MidtransNewCreditCardViewController alloc] initWithToken:nil paymentMethodName:nil andCreditCardData:nil andCompleteResponseOfPayment:nil];
        creditCardVC.saveCreditCardOnly = YES;
        creditCardVC.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.add.new.card"];
        [creditCardVC showDismissButton:creditCardVC.saveCreditCardOnly];
        [self.navigationController pushViewController:creditCardVC animated:!creditCardVC.saveCreditCardOnly];
        return;
        
    }
    self.tableHeaderHeight = DEFAULT_HEADER_HEIGHT;
    self.title =  [VTClassHelper getTranslationFromAppBundleForString:@"payment.list.title"];
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

    [self loadPaymentList];
  
}
- (void)loadPaymentList {
    
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", @"paymentMethods"];
    NSString *path = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (path == nil) {
        path = [VTBundle pathForResource:@"en_paymentMethods" ofType:@"plist"];
    }
    
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];
    
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Loading payment list"]];
    
    if (self.token.tokenId.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[VTClassHelper getTranslationFromAppBundleForString:@"alert.invalid-payment-token"]
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
    [[MidtransMerchantClient shared] requestPaymentlistWithToken:self.token.tokenId
                                                      completion:^(MidtransPaymentRequestV2Response * _Nullable response, NSError * _Nullable error)
     {
         self.title = response.merchant.preference.displayName;
         [[NSUserDefaults standardUserDefaults] setObject:response.merchant.preference.displayName forKey:MIDTRANS_CORE_MERCHANT_NAME];
         [[NSUserDefaults standardUserDefaults] setObject:self.token.tokenId forKey:MIDTRANS_CORE_CURRENT_TOKEN];
         [[NSUserDefaults standardUserDefaults] setObject:response.merchant.merchantId forKey:MIDTRANS_TRACKING_MERCHANT_ID];
         [[NSUserDefaults standardUserDefaults] synchronize];
         if (response) {
             NSArray* strings = [response.enabledPayments valueForKeyPath:@"@distinctUnionOfObjects.type"];
             [[NSUserDefaults standardUserDefaults] setObject:strings forKey:MIDTRANS_TRACKING_ENABLED_PAYMENTS];

             NSMutableArray *array = [[NSMutableArray alloc] initWithArray:response.merchant.enabledPrinciples];
             NSString *imagePath = [NSString stringWithFormat:@"%@-seal",[array componentsJoinedByString:@"-"]];
             
             [self.view.secureBadgeImage setImage:[[UIImage imageNamed:imagePath inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
             
             //applying SNAP color if any
             UIColor *snapColor = [self colorFromSnapScheme:response.merchant.preference.colorScheme];
             [MidtransUIThemeManager applySnapThemeColor:snapColor];
             [self reloadThemeColor];
             
             //handle payment list
             self.responsePayment = response;
             bool vaAlreadyAdded = 0;
             NSInteger mainIndex = 0;
             MidtransPaymentListModel *model;
             
             NSDictionary *vaDictionaryBuilder = @{@"description":[VTClassHelper getTranslationFromAppBundleForString:@"Pay from ATM Bersama, Prima or Alto"],
                                                   @"id":@"va",
                                                   @"identifier":@"va",
                                                   @"shortName":@"atm transfer",
                                                   @"title":@"ATM/Bank Transfer"
                                                   };
             
             NSArray *paymentAvailable = response.enabledPayments;
             if ([self.paymentMethodSelected isEqualToString:@"bank_transfer"]) {
                 model = [[MidtransPaymentListModel alloc] initWithDictionary:vaDictionaryBuilder];
                 [self.paymentMethodList insertObject:model atIndex:0];
                 [self hideLoading];
                 self.singlePayment = YES;
                 [self redirectToPaymentMethodAtIndex:0];
             }
             if (self.paymentMethodSelected.length > 0) {
                 /*special case*/
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

                     if (index !=NSNotFound) {
                         self.singlePayment = YES;
                         model = [[MidtransPaymentListModel alloc] initWithDictionary:paymentList[index]];
                         model.status = enabledPayment.status;
                         [self.paymentMethodList addObject:model];
                         [self redirectToPaymentMethodAtIndex:0];
                     }
                 }
                 else {
                     index = [paymentList indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         return [obj[@"id"] isEqualToString:enabledPayment.type];
                     }];
                 }
                 
                 if (index != NSNotFound) {
                     if ([enabledPayment.category isEqualToString:@"bank_transfer"] || [enabledPayment.type isEqualToString:@"echannel"]) {
                         if (response.enabledPayments.count == 1) {
                             self.bankTransferOnly = 1;
                         }
                         
                         if (!vaAlreadyAdded) {
                                 model = [[MidtransPaymentListModel alloc] initWithDictionary:vaDictionaryBuilder];
                                 model.status = enabledPayment.status;
                                 self.paymentMethodList.count > 0 ? [self.paymentMethodList insertObject:model atIndex:1]:[self.paymentMethodList addObject:model];
                                 vaAlreadyAdded = YES;
                         }
                     }
                     
                     else {
                         self.bankTransferOnly = 0;
                         model = [[MidtransPaymentListModel alloc] initWithDictionary:paymentList[index]];
                         model.status = enabledPayment.status;
                         [self.paymentMethodList addObject:model];
                         
                     }
                     mainIndex++;
                 }
                  [self hideLoading];
                 if (response.enabledPayments.count) {
                     [self.view setPaymentMethods:self.paymentMethodList andItems:self.token.itemDetails withResponse:response];
                 }
                 else if (self.paymentMethodSelected.length > 0 || response.enabledPayments.count == 1) {
                     self.singlePayment = YES;
                     [self redirectToPaymentMethodAtIndex:0];
                 }
                 
             }
             if (self.paymentMethodSelected.length > 0 || response.enabledPayments.count ==1 || self.bankTransferOnly) {
                 self.singlePayment = YES;
                 [self redirectToPaymentMethodAtIndex:0];
             }
             
         }
         else {
             [self hideLoading];
             
             [self showMaintainViewWithTtitle:@"we're currently down for maintenance" andContent:@"We expect to be back in a couple hours. Thanks for your patience" andButtonTitle:@"okay,bring me back"];
             NSDictionary *userInfo = @{TRANSACTION_ERROR_KEY:error};
             [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_FAILED object:nil userInfo:userInfo];
         }
         
         [self hideLoading];
     }];

}

- (void)closePressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_CANCELED object:nil];
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    if ([currentWindow viewWithTag:100101]) {
         [[currentWindow viewWithTag:100101] removeFromSuperview];
    }
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadThemeColor {
    UIColor *color = [[MidtransUIThemeManager shared] themeColor];
    self.navigationController.navigationBar.tintColor = color;
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
    NSString *eventName = [NSString stringWithFormat:@"pg %@",[paymentMethodName stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
    if (self.responsePayment.transactionDetails.orderId) {
        [[SNPUITrackingManager shared] trackEventName:eventName additionalParameters:@{@"order id": self.responsePayment.transactionDetails.orderId}];
    } else {
        [[SNPUITrackingManager shared] trackEventName:eventName];
    }
    if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_OTHER_VA] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_VA] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_ECHANNEL] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BNI_VA] ||
             [paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA]){
  
        MidtransPaymentListModel *vaTypeModel = [[MidtransPaymentListModel alloc] initWithDictionary:[paymentMethod dictionaryRepresentation]];
       
   
        MidtransVAViewController *vc = [[MidtransVAViewController alloc] initWithToken:self.token paymentMethodName:vaTypeModel];
        vc.response = self.responsePayment;
        [vc showDismissButton:YES];
        
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
        return;
    }
    
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
               // vc.promos = self.responsePayment.promos;
                [vc showDismissButton:self.singlePayment];
                [self.navigationController pushViewController:vc animated:!self.singlePayment];
                
            }
            else {
                NSMutableDictionary *additionalData = [NSMutableDictionary dictionaryWithDictionary:@{@"card mode":@"normal"}];
                if (self.responsePayment.transactionDetails.orderId) {
                    [additionalData addEntriesFromDictionary:@{@"order id":self.responsePayment.transactionDetails.orderId}];
                }
                [[SNPUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:additionalData];

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
                        [vc showDismissButton:self.singlePayment];
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
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_DANAMON_ONLINE]) {
        MIDDanamonOnlineViewController *vc = [[MIDDanamonOnlineViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
        [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_KLIK_BCA] ||
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
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_GOPAY]) {
        MidGopayViewController *midGopayVC = [[MidGopayViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
        [midGopayVC showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:midGopayVC animated:!self.singlePayment];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET]) {
        MIDPaymentIndomaretViewController* vc = [[MIDPaymentIndomaretViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
        [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
    else {
        MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
        [vc showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:vc animated:!self.singlePayment];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
