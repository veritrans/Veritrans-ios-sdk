//
//  VTPaymentListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/22/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//
#define IS_IPAD (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
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
#import "MIDAlfamartViewController.h"
#import "MidShopeePayViewController.h"
#import "MIDUobMenuController.h"
#define DEFAULT_HEADER_HEIGHT 80;
#define SMALL_HEADER_HEIGHT 40;

@interface VTPaymentListController () <UITableViewDelegate, VTPaymentListViewDelegate>
@property (strong, nonatomic) IBOutlet VTPaymentListView *view;
@property (nonatomic,strong) NSMutableArray *paymentMethodList;
@property (nonatomic,strong) MidtransPaymentRequestV2Response *responsePayment;
@property (nonatomic)BOOL singlePayment;
@property (nonatomic) BOOL bankTransferOnly;
@property (nonatomic) CGFloat tableHeaderHeight;
@property (nonatomic) NSString* qrisAcquirer;
@property (nonatomic) MidtransPromoPromoDetails* promoResponse;

@end

@implementation VTPaymentListController;

@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self setupNavigationBar];
    [self setupMerchantLogo];
    [self initializePaymentMethodList];
    [self loadPaymentList];
    
}
- (void)loadPaymentList {
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Loading payment list"]];
    
    if (![self isTokenValid]) {
        [self showAlertForInvalidToken];
        return;
    }
    
    [[MidtransMerchantClient shared] requestPaymentlistWithToken:self.token.tokenId
                                                      completion:^(MidtransPaymentRequestV2Response * _Nullable response, NSError * _Nullable error) {
        [self handlePaymentListResponse:response error:error];
    }];
}

- (void)closePressed:(id)sender {
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    if ([currentWindow viewWithTag:100101]) {
        [[currentWindow viewWithTag:100101] removeFromSuperview];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_CANCELED object:nil];
    }];
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

#pragma mark - Helper for redirectToPaymentMethod
- (void)redirectToPaymentMethodAtIndex:(NSInteger)index {
    MidtransPaymentListModel *paymentMethod = (MidtransPaymentListModel *)[self.paymentMethodList objectAtIndex:index];
    NSString *paymentMethodName = paymentMethod.shortName;
    NSString *eventName = [NSString stringWithFormat:@"pg %@", [paymentMethodName stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
    
    [self trackEventForPaymentMethod:paymentMethodName withOrderId:self.responsePayment.transactionDetails.orderId];
    
    if ([self isVirtualAccountPayment:paymentMethod.internalBaseClassIdentifier]) {
        [self redirectToVirtualAccountPayment:paymentMethod];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
        [self redirectToCreditCardPayment:paymentMethod];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_VA]) {
        [self redirectToVAPayment:paymentMethod];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_UOB]) {
        [self redirectToUOBPayment:paymentMethod];
    }
    else if ([self isGeneralPaymentMethod:paymentMethod.internalBaseClassIdentifier]) {
        [self redirectToGeneralPayment:paymentMethod];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_DANAMON_ONLINE]) {
        [self redirectToDanamonOnlinePayment:paymentMethod];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_ALFAMART]) {
        [self redirectToAlfamartPayment:paymentMethod];
    }
    else if ([self isDirectPaymentMethod:paymentMethod.internalBaseClassIdentifier]) {
        [self redirectToDirectPayment:paymentMethod];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_GCI]) {
        [self redirectToGCIPayment:paymentMethod];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_MANDIRI_CLICKPAY]) {
        [self redirectToMandiriClickpay:paymentMethod];
    }
    else if ([self isGopayOrShopeePay:paymentMethod.internalBaseClassIdentifier]) {
        [self redirectToGopayOrShopeePay:paymentMethod];
    }
    else if ([paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_INDOMARET]) {
        [self redirectToIndomaretPayment:paymentMethod];
    }
    else {
        [self redirectToFallbackPayment:paymentMethod];
    }
}

#pragma mark - Helper Methods

- (void)trackEventForPaymentMethod:(NSString *)paymentMethodName withOrderId:(NSString *)orderId {
    NSString *eventName = [NSString stringWithFormat:@"pg %@", [paymentMethodName stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
    if (orderId) {
        [[SNPUITrackingManager shared] trackEventName:eventName additionalParameters:@{@"order id": orderId}];
    } else {
        [[SNPUITrackingManager shared] trackEventName:eventName];
    }
}

- (BOOL)isVirtualAccountPayment:(NSString *)identifier {
    NSArray *virtualAccountPayments = @[MIDTRANS_PAYMENT_OTHER_VA,
                                        MIDTRANS_PAYMENT_BCA_VA,
                                        MIDTRANS_PAYMENT_ECHANNEL,
                                        MIDTRANS_PAYMENT_BNI_VA,
                                        MIDTRANS_PAYMENT_BRI_VA,
                                        MIDTRANS_PAYMENT_CIMB_VA,
                                        MIDTRANS_PAYMENT_PERMATA_VA];
    return [virtualAccountPayments containsObject:identifier];
}

- (void)redirectToVirtualAccountPayment:(MidtransPaymentListModel *)paymentMethod {
    MidtransVAViewController *vc = [[MidtransVAViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    vc.response = self.responsePayment;
    [vc showDismissButton:YES];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}

- (void)redirectToCreditCardPayment:(MidtransPaymentListModel *)paymentMethod {
    if ([CC_CONFIG paymentType] == MTCreditCardPaymentTypeNormal && !PRIVATECONFIG.isSnapTokenFlow) {
        MidtransNewCreditCardViewController *creditCardVC = [[MidtransNewCreditCardViewController alloc]
                                                             initWithToken:self.token
                                                             paymentMethodName:paymentMethod
                                                             andCreditCardData:self.responsePayment.creditCard
                                                             andCompleteResponseOfPayment:self.responsePayment];
        creditCardVC.promos = self.promoResponse;
        [creditCardVC showDismissButton:self.singlePayment];
        [self.navigationController pushViewController:creditCardVC animated:!self.singlePayment];
    } else {
        if (self.responsePayment.creditCard.savedTokens.count) {
            MidtransSavedCardController *vc = [[MidtransSavedCardController alloc]
                                               initWithToken:self.token
                                               paymentMethodName:paymentMethod
                                               andCreditCardData:self.responsePayment.creditCard
                                               andCompleteResponseOfPayment:self.responsePayment];
            [vc showDismissButton:self.singlePayment];
            [self.navigationController pushViewController:vc animated:!self.singlePayment];
        } else {
            [self trackCreditCardDetailsEvent];
            MidtransNewCreditCardViewController *creditCardVC = [[MidtransNewCreditCardViewController alloc]
                                                                 initWithToken:self.token
                                                                 paymentMethodName:paymentMethod
                                                                 andCreditCardData:self.responsePayment.creditCard
                                                                 andCompleteResponseOfPayment:self.responsePayment];
            creditCardVC.promos = self.promoResponse;
            [creditCardVC showDismissButton:self.singlePayment];
            [self.navigationController pushViewController:creditCardVC animated:!self.singlePayment];
        }
    }
}

- (void)trackCreditCardDetailsEvent {
    NSMutableDictionary *additionalData = [NSMutableDictionary dictionaryWithDictionary:@{@"card mode": @"normal"}];
    if (self.responsePayment.transactionDetails.orderId) {
        [additionalData addEntriesFromDictionary:@{@"order id": self.responsePayment.transactionDetails.orderId}];
    }
    [[SNPUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:additionalData];
}

- (void)redirectToVAPayment:(MidtransPaymentListModel *)paymentMethod {
    VTVAListController *vc = [[VTVAListController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    vc.paymentResponse = self.responsePayment;
    [vc showDismissButton:self.singlePayment];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}

- (void)redirectToUOBPayment:(MidtransPaymentListModel *)paymentMethod {
    MIDUobMenuController *vc = [[MIDUobMenuController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    vc.paymentResponse = self.responsePayment;
    [vc showDismissButton:self.singlePayment];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}

- (BOOL)isGeneralPaymentMethod:(NSString *)identifier {
    NSArray *generalPayments = @[MIDTRANS_PAYMENT_CIMB_CLICKS,
                                 MIDTRANS_PAYMENT_MANDIRI_ECASH,
                                 MIDTRANS_PAYMENT_BCA_KLIKPAY,
                                 MIDTRANS_PAYMENT_BRI_EPAY,
                                 MIDTRANS_PAYMENT_AKULAKU,
                                 MIDTRANS_PAYMENT_KREDIVO,
                                 MIDTRANS_PAYMENT_XL_TUNAI];
    return [generalPayments containsObject:identifier];
}

- (void)redirectToGeneralPayment:(MidtransPaymentListModel *)paymentMethod {
    MidtransUIPaymentGeneralViewController *vc = [[MidtransUIPaymentGeneralViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod merchant:self.responsePayment.merchant];
    [vc showDismissButton:self.singlePayment];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}

- (void)redirectToDanamonOnlinePayment:(MidtransPaymentListModel *)paymentMethod {
    MIDDanamonOnlineViewController *vc = [[MIDDanamonOnlineViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    [vc showDismissButton:self.singlePayment];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}

- (void)redirectToAlfamartPayment:(MidtransPaymentListModel *)paymentMethod {
    MIDAlfamartViewController *vc = [[MIDAlfamartViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    [vc showDismissButton:self.singlePayment];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}

- (BOOL)isDirectPaymentMethod:(NSString *)identifier {
    NSArray *directPayments = @[MIDTRANS_PAYMENT_KLIK_BCA, MIDTRANS_PAYMENT_TELKOMSEL_CASH, MIDTRANS_PAYMENT_INDOSAT_DOMPETKU,
                                MIDTRANS_PAYMENT_KIOS_ON, MIDTRANS_PAYMENT_AKULAKU, MIDTRANS_PAYMENT_KREDIVO];
    return [directPayments containsObject:identifier];
}

- (void)redirectToDirectPayment:(MidtransPaymentListModel *)paymentMethod {
    MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    [vc showDismissButton:self.singlePayment];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}

- (void)redirectToGCIPayment:(MidtransPaymentListModel *)paymentMethod {
    MidtransPaymentGCIViewController *vc = [[MidtransPaymentGCIViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)redirectToMandiriClickpay:(MidtransPaymentListModel *)paymentMethod {
    VTMandiriClickpayController *vc = [[VTMandiriClickpayController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    [vc showDismissButton:self.singlePayment];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}

- (BOOL)isGopayOrShopeePay:(NSString *)identifier {
    NSArray *gopayOrShopeePay = @[MIDTRANS_PAYMENT_GOPAY, MIDTRANS_PAYMENT_QRIS_GOPAY,
                                  MIDTRANS_PAYMENT_SHOPEEPAY, MIDTRANS_PAYMENT_QRIS_SHOPEEPAY];
    return [gopayOrShopeePay containsObject:identifier];
}

- (void)redirectToGopayOrShopeePay:(MidtransPaymentListModel *)paymentMethod {
    NSString *identifier = [paymentMethod.internalBaseClassIdentifier stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([identifier caseInsensitiveCompare:MIDTRANS_PAYMENT_GOPAY] == NSOrderedSame ||
        [identifier caseInsensitiveCompare:MIDTRANS_PAYMENT_QRIS_GOPAY] == NSOrderedSame) {
        
        MidGopayViewController *midGopayVC = [[MidGopayViewController alloc] initWithToken:self.token
                                                                         paymentMethodName:paymentMethod
                                                                      directPaymentFeature:self.singlePayment];
        [self.navigationController pushViewController:midGopayVC animated:!self.singlePayment];
        
    } else {
        MidShopeePayViewController *midShopeepayVC = [[MidShopeePayViewController alloc] initWithToken:self.token
                                                                                     paymentMethodName:paymentMethod
                                                                                  directPaymentFeature:self.singlePayment];
        [self.navigationController pushViewController:midShopeepayVC animated:!self.singlePayment];
    }
}

- (void)redirectToIndomaretPayment:(MidtransPaymentListModel *)paymentMethod {
    MIDPaymentIndomaretViewController *vc = [[MIDPaymentIndomaretViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    [vc showDismissButton:self.singlePayment];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}

- (void)redirectToFallbackPayment:(MidtransPaymentListModel *)paymentMethod {
    MidtransUIPaymentDirectViewController *vc = [[MidtransUIPaymentDirectViewController alloc] initWithToken:self.token paymentMethodName:paymentMethod];
    [vc showDismissButton:self.singlePayment];
    [self.navigationController pushViewController:vc animated:!self.singlePayment];
}


#pragma mark - ProcessResponse Methods
- (void)processResponse:(MidtransPaymentRequestV2Response *)response {
    // Load payment methods based on current language
    NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", @"paymentMethods"];
    NSString *path = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (!path) {
        path = [VTBundle pathForResource:@"en_paymentMethods" ofType:@"plist"];
    }
    NSArray *paymentList = [NSArray arrayWithContentsOfFile:path];
    NSArray *enabledPaymentTypes = [response.enabledPayments valueForKeyPath:@"@distinctUnionOfObjects.type"];
    [[NSUserDefaults standardUserDefaults] setObject:enabledPaymentTypes forKey:MIDTRANS_TRACKING_ENABLED_PAYMENTS];
    
    // Set secure badge image based on enabled principles
    [self setSecureBadgeImageWithPrinciples:response.merchant.enabledPrinciples];
    
    // Apply SNAP color scheme if available
    [self applySnapColorScheme:response.merchant.preference.colorScheme];
    
    // Handle payment list
    self.responsePayment = response;
    self.singlePayment = NO;
    
    if ([self shouldAddBankTransfer]) {
        [self addBankTransferPaymentModel];
    }
    
    if ([self.paymentMethodSelected isEqualToString:@"bank_transfer"]) {
        [self handleBankTransferSelection];
    } else if (self.paymentMethodSelected.length > 0) {
        if (![self handleSpecialPaymentSelection:response paymentList:paymentList]) {
            self.view.emptyView.hidden = NO;
            return;
        }
    } else {
        [self populatePaymentMethods:response paymentList:paymentList];
    }
    
    if ([self shouldRedirectToSinglePayment]) {
        [self redirectToPaymentMethodAtIndex:0];
    }
    
    [self hideLoading];
}

#pragma mark - Helper Methods

- (void)setSecureBadgeImageWithPrinciples:(NSArray *)enabledPrinciples {
    NSString *imagePath = [NSString stringWithFormat:@"%@-seal", [enabledPrinciples componentsJoinedByString:@"-"]];
    UIImage *image = [[UIImage imageNamed:imagePath inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.view.secureBadgeImage setImage:image];
}

- (void)applySnapColorScheme:(NSString *)colorScheme {
    UIColor *snapColor = [self colorFromSnapScheme:colorScheme];
    [MidtransUIThemeManager applySnapThemeColor:snapColor];
    [self reloadThemeColor];
}

- (BOOL)shouldAddBankTransfer {
    return [self.paymentMethodSelected isEqualToString:@"bank_transfer"];
}

- (void)addBankTransferPaymentModel {
    NSDictionary *vaDictionaryBuilder = @{
        @"description": [VTClassHelper getTranslationFromAppBundleForString:@"Pay from ATM Bersama, Prima or Alto"],
        @"id": @"va",
        @"identifier": @"va",
        @"shortName": @"atm transfer",
        @"title": @"ATM/Bank Transfer"
    };
    MidtransPaymentListModel *model = [[MidtransPaymentListModel alloc] initWithDictionary:vaDictionaryBuilder];
    [self.paymentMethodList insertObject:model atIndex:0];
}

- (void)handleBankTransferSelection {
    [self hideLoading];
    self.singlePayment = YES;
    [self redirectToPaymentMethodAtIndex:0];
}

- (BOOL)handleSpecialPaymentSelection:(MidtransPaymentRequestV2Response *)response paymentList:(NSArray *)paymentList {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", self.paymentMethodSelected];
    NSArray *filteredPayments = [response.enabledPayments filteredArrayUsingPredicate:predicate];
    
    if (filteredPayments.count == 0) {
        return NO;
    }
    
    [self addFilteredPaymentMethods:filteredPayments toPaymentList:paymentList];
    return YES;
}

- (void)addFilteredPaymentMethods:(NSArray *)filteredPayments toPaymentList:(NSArray *)paymentList {
    for (MidtransPaymentRequestV2EnabledPayments *enabledPayment in filteredPayments) {
        NSInteger index = [self findPaymentMethodIndexInList:paymentList forEnabledPayment:enabledPayment];
        
        if (index != NSNotFound) {
            MidtransPaymentListModel *model = [[MidtransPaymentListModel alloc] initWithDictionary:paymentList[index]];
            model.status = enabledPayment.status;
            [self.paymentMethodList addObject:model];
        }
    }
}

- (void)populatePaymentMethods:(MidtransPaymentRequestV2Response *)response paymentList:(NSArray *)paymentList {
    BOOL vaAlreadyAdded = NO;
    NSInteger mainIndex = 0;
    
    for (MidtransPaymentRequestV2EnabledPayments *enabledPayment in response.enabledPayments) {
        NSInteger index = [self findPaymentMethodIndexInList:paymentList forEnabledPayment:enabledPayment];
        
        if (index != NSNotFound) {
            [self handleEnabledPayment:enabledPayment atPaymentIndex:index vaAlreadyAdded:&vaAlreadyAdded paymentList:paymentList];
            mainIndex++;
        }
    }
    
    if (response.enabledPayments.count > 0) {
        [self.view setPaymentMethods:self.paymentMethodList andItems:self.token.itemDetails withResponse:response promos:self.promoResponse];
    }
}

- (NSInteger)findPaymentMethodIndexInList:(NSArray *)paymentList forEnabledPayment:(MidtransPaymentRequestV2EnabledPayments *)enabledPayment {
    return [paymentList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if (IS_IPAD) {
            if ([enabledPayment.type isEqualToString:MIDTRANS_PAYMENT_QRIS] && enabledPayment.acquirer) {
                self.qrisAcquirer = [NSString stringWithFormat:@"%@%@", enabledPayment.type, enabledPayment.acquirer];
                return [obj[@"id"] isEqualToString:self.qrisAcquirer];
            } else if ([enabledPayment.type isEqualToString:MIDTRANS_PAYMENT_SHOPEEPAY] ||
                       [enabledPayment.type isEqualToString:MIDTRANS_PAYMENT_GOPAY]) {
                return NO;
            } else {
                return [obj[@"id"] isEqualToString:enabledPayment.type];
            }
        } else {
            return [obj[@"id"] isEqualToString:enabledPayment.type];
        }
    }];
}

- (void)handleEnabledPayment:(MidtransPaymentRequestV2EnabledPayments *)enabledPayment
              atPaymentIndex:(NSInteger)index
              vaAlreadyAdded:(BOOL *)vaAlreadyAdded
                 paymentList:(NSArray *)paymentList {
    
    MidtransPaymentListModel *model;
    
    if ([enabledPayment.category isEqualToString:@"bank_transfer"] || [enabledPayment.type isEqualToString:@"echannel"]) {
        if (self.responsePayment.enabledPayments.count == 1) {
            self.bankTransferOnly = YES;
        }
        
        if (!*vaAlreadyAdded) {
            [self addBankTransferPaymentModel];
            *vaAlreadyAdded = YES;
        }
    } else {
        self.bankTransferOnly = NO;
        model = [[MidtransPaymentListModel alloc] initWithDictionary:paymentList[index]];
        model.status = enabledPayment.status;
        [self.paymentMethodList addObject:model];
    }
}

- (BOOL)shouldRedirectToSinglePayment {
    return self.paymentMethodSelected.length > 0 ||
    self.responsePayment.enabledPayments.count == 1 ||
    self.bankTransferOnly;
}

#pragma mark - Helper Methods to Configure ViewDidLoad

- (void)configureView {
    self.view.delegate = self;
    self.tableHeaderHeight = DEFAULT_HEADER_HEIGHT;
    self.title = [VTClassHelper getTranslationFromAppBundleForString:@"payment.list.title"];
    self.singlePayment = NO;
}

- (void)setupNavigationBar {
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)setupMerchantLogo {
    UIImage *logo = [MidtransImageManager merchantLogo];
    if (logo) {
        UIView *titleViewWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:titleViewWrapper.frame];
        [imgView setImage:logo];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        [titleViewWrapper addSubview:imgView];
        self.navigationItem.titleView = titleViewWrapper;
    }
}

- (void)initializePaymentMethodList {
    self.paymentMethodList = [NSMutableArray new];
}


#pragma mark - Helper Methods for LoadPaymentList

- (BOOL)isTokenValid {
    return self.token.tokenId.length > 0;
}

- (void)showAlertForInvalidToken {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Error"
                                message:[VTClassHelper getTranslationFromAppBundleForString:@"alert.invalid-payment-token"]
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
                               actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handlePaymentListResponse:(MidtransPaymentRequestV2Response * _Nullable)response error:(NSError * _Nullable)error {
    if (response) {
        [self updateMerchantPreferencesWithResponse:response];
        [self handlePromotionsIfAvailable:response];
        [self processResponse:response];
    } else {
        [self handlePaymentListError:error];
    }
}

- (void)updateMerchantPreferencesWithResponse:(MidtransPaymentRequestV2Response *)response {
    self.title = response.merchant.preference.displayName;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:response.merchant.preference.displayName forKey:MIDTRANS_CORE_MERCHANT_NAME];
    [defaults setObject:self.token.tokenId forKey:MIDTRANS_CORE_CURRENT_TOKEN];
    [defaults setObject:response.merchant.merchantId forKey:MIDTRANS_TRACKING_MERCHANT_ID];
    [defaults synchronize];
}

- (void)handlePromotionsIfAvailable:(MidtransPaymentRequestV2Response *)response {
    if ([response.featureTypes containsObject:FEATURE_TYPES_PROMO]) {
        [[MidtransMerchantClient shared] getPromoWithToken:response.token
                                                completion:^(MidtransPromoPromoDetails * _Nullable promoResponse, NSError * _Nullable error) {
            if (promoResponse) {
                self.promoResponse = promoResponse;
            }
        }];
    }
}

- (void)handlePaymentListError:(NSError *)error {
    [self hideLoading];
    [self showMaintainViewWithTtitle:@"we're currently down for maintenance"
                          andContent:@"We expect to be back in a couple hours. Thanks for your patience"
                      andButtonTitle:@"okay, bring me back"];
    
    NSDictionary *userInfo = @{TRANSACTION_ERROR_KEY: error};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_FAILED object:nil userInfo:userInfo];
}
@end
