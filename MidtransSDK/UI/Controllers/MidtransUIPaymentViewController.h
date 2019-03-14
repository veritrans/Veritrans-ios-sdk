//
//  VTPaymentViewController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/25/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransUIFontSource.h"

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
    MidtransPaymentFeatureAkulaku,
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
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController saveCardFailed:(NSError *)error;
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error;
- (void)paymentViewController_paymentCanceled:(MidtransUIPaymentViewController *)viewController;
@end

@interface MidtransUIPaymentViewController : UINavigationController
- (instancetype)initCreditCardForm;
@property (nonatomic, strong) id<MidtransUIPaymentViewControllerDelegate> paymentDelegate;

@end
