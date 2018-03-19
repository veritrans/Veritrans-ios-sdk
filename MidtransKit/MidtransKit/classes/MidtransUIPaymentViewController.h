//
//  VTPaymentViewController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransUIFontSource.h"

/*
 static NSString * const MIDTRANS_PAYMENT_BCA_KLIKPAY = @"bca_klikpay";
 static NSString * const MIDTRANS_PAYMENT_KLIK_BCA = @"bca_klikbca";
 static NSString * const MIDTRANS_PAYMENT_INDOMARET = @"indomaret";
 static NSString * const MIDTRANS_PAYMENT_CIMB_CLICKS = @"cimb_clicks";
 static NSString * const MIDTRANS_PAYMENT_CSTORE = @"cstore";
 static NSString * const MIDTRANS_PAYMENT_MANDIRI_ECASH = @"mandiri_ecash";
 static NSString * const MIDTRANS_PAYMENT_CREDIT_CARD = @"credit_card";

 static NSString * const MIDTRANS_PAYMENT_ECHANNEL = @"echannel";
 static NSString * const MIDTRANS_PAYMENT_PERMATA_VA = @"permata_va";
 static NSString * const MIDTRANS_PAYMENT_BCA_VA = @"bca_va";
 static NSString * const MIDTRANS_PAYMENT_ALL_VA = @"all_va";
 static NSString * const MIDTRANS_PAYMENT_OTHER_VA= @"other_va";
 static NSString * const MIDTRANS_PAYMENT_VA = @"va";

 static NSString * const MIDTRANS_PAYMENT_BRI_EPAY = @"bri_epay";
 static NSString * const MIDTRANS_PAYMENT_TELKOMSEL_CASH = @"telkomsel_cash";
 static NSString * const MIDTRANS_PAYMENT_INDOSAT_DOMPETKU = @"indosat_dompetku";
 static NSString * const MIDTRANS_PAYMENT_XL_TUNAI = @"xl_tunai";
 static NSString * const MIDTRANS_PAYMENT_MANDIRI_CLICKPAY = @"mandiri_clickpay";
 static NSString * const MIDTRANS_PAYMENT_KIOS_ON = @"kioson";
 */
typedef NS_ENUM(NSInteger, MidtransPaymentFeature) {
    MidtransPaymentFeatureCreditCard,
    MidtransPaymentFeatureBankTransfer,///va
    MidtransPaymentFeatureBankTransferBCAVA,
    MidtransPaymentFeatureBankTransferMandiriVA,
    MidtransPaymentFeatureBankTransferBNIVA,
    MidtransPaymentFeatureBankTransferPermataVA,
    MidtransPaymentFeatureBankTransferOtherVA,
    MidtransPaymentFeatureKlikBCA,
    MidtransPaymentFeatureIndomaret,
    MidtransPaymentFeatureCIMBClicks,
    MidtransPaymentFeatureCStore,
    midtranspaymentfeatureBCAKlikPay,
    MidtransPaymentFeatureMandiriEcash,
    MidtransPaymentFeatureEchannel,
    MidtransPaymentFeaturePermataVA,
    MidtransPaymentFeatureBRIEpay,
    MidtransPaymentFeatureTelkomselEcash,
    MidtransPyamentFeatureDanamonOnline,
    MidtransPaymentFeatureIndosatDompetku,
    MidtransPaymentFeatureXLTunai,
    MidtransPaymentFeatureMandiriClickPay,
    MidtransPaymentFeatureKiosON,
    MidtransPaymentFeatureGCI,
    MidtransPaymentFeatureGOPAY,
    MidtransPaymentCreditCardForm
};
@class MidtransUIPaymentViewController;

@protocol MidtransUIPaymentViewControllerDelegate;

@protocol MidtransUIPaymentViewControllerDelegate <NSObject>
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController saveCard:(MidtransMaskedCreditCard *)result;
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController saveCardFailed:(NSError *)error;
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result;
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result;
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error;
- (void)paymentViewController_paymentCanceled:(MidtransUIPaymentViewController *)viewController;
@end

@interface MidtransUIPaymentViewController : UINavigationController
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token;
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token andPaymentFeature:(MidtransPaymentFeature)paymentFeature;
- (instancetype)initCreditCardForm;
@property (nonatomic, strong) id<MidtransUIPaymentViewControllerDelegate> paymentDelegate;

@end
