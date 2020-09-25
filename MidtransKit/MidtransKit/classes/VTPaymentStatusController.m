//
//  VTPaymentStatusController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/7/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentStatusController.h"
#import "VTClassHelper.h"
#import "VTKITConstant.h"
#import "MidtransUIThemeManager.h"
#import "MIdtransUIBorderedView.h"

typedef NS_ENUM(NSUInteger, SNPStatusType) {
    SNPStatusTypeSuccess = 1,
    SNPStatusTypeError = 2,
    SNPStatusTypePending = 3,
    SNPStatusTypeDeny = 4
};

@interface VTPaymentStatusController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusIconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueInstallmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dueInstallmentConstraint;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *dueInstallmentBorderView;

@property (nonatomic) MidtransTransactionResult *result;
@property (nonatomic) NSError *error;
@property (nonatomic) MidtransTransactionTokenResponse *token;
@property (nonatomic) MidtransPaymentListModel *paymentMethod;

@property (nonatomic, assign) SNPStatusType statusType;

@property (nonatomic) CAGradientLayer *gradientLayer;
@end

@implementation VTPaymentStatusController

+ (instancetype)successTransactionWithResult:(MidtransTransactionResult *)result
                                       token:(MidtransTransactionTokenResponse *)token
                               paymentMethod:(MidtransPaymentListModel *)paymentMethod {
    VTPaymentStatusController *vc = [[VTPaymentStatusController alloc] initWithNibName:NSStringFromClass([VTPaymentStatusController class]) bundle:VTBundle];
    
    vc.statusType = SNPStatusTypeSuccess;
    vc.result = result;
    vc.token = token;
    vc.paymentMethod = paymentMethod;
    return vc;
}

+ (instancetype)errorTransactionWithError:(NSError *)error
                                    token:(MidtransTransactionTokenResponse *)token
                            paymentMethod:(MidtransPaymentListModel *)paymentMethod {
    VTPaymentStatusController *vc = [[VTPaymentStatusController alloc] initWithNibName:NSStringFromClass([VTPaymentStatusController class]) bundle:VTBundle];
    vc.statusType = SNPStatusTypeError;
    vc.error = error;
    vc.token = token;
    vc.paymentMethod = paymentMethod;
    return vc;
}

+ (instancetype)pendingTransactionWithResult:(MidtransTransactionResult *)result
                                       token:(MidtransTransactionTokenResponse *)token
                               paymentMethod:(MidtransPaymentListModel *)paymentMethod {
    VTPaymentStatusController *vc = [[VTPaymentStatusController alloc] initWithNibName:NSStringFromClass([VTPaymentStatusController class]) bundle:VTBundle];
    vc.statusType = SNPStatusTypePending;
    vc.result = result;
    vc.token = token;
    vc.paymentMethod = paymentMethod;
    return vc;
}

+ (instancetype)denyTransactionWithResult:(MidtransTransactionResult *)result token:(MidtransTransactionTokenResponse *)token paymentMethod:(MidtransPaymentListModel *)paymentMethod{
    VTPaymentStatusController *vc = [[VTPaymentStatusController alloc] initWithNibName:NSStringFromClass([VTPaymentStatusController class]) bundle:VTBundle];
    vc.statusType = SNPStatusTypeDeny;
    vc.result = result;
    vc.token = token;
    vc.paymentMethod = paymentMethod;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    bar.shadowImage = [UIImage new];
    bar.translucent = YES;
    bar.titleTextAttributes = @{
        NSFontAttributeName:[[MidtransUIThemeManager shared].themeFont fontRegularWithSize:17],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    NSMutableDictionary * additionalData = [[NSMutableDictionary alloc] init];
    if (self.result.transactionId) {
        [additionalData addEntriesFromDictionary:@{@"transaction id": self.result.transactionId}];
    }
    if (self.result.orderId) {
        [additionalData addEntriesFromDictionary:@{@"order id": self.result.orderId}];
    }
    id oneclick = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_TRACKING_ONE_CLICK_AVAILABLE];
    id twoclick = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_TRACKING_TWO_CLICK_AVAILABLE];
    if (oneclick) {
        [additionalData addEntriesFromDictionary:@{@"1 click token available": oneclick}];
    }
    if (twoclick) {
        [additionalData addEntriesFromDictionary:@{@"2 clicks token available": twoclick}];
    }
    id available = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_TRACKING_INSTALLMENT_AVAILABLE];
    id required = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_TRACKING_INSTALLMENT_REQUIRED];
    if (available && required) {
        [additionalData addEntriesFromDictionary:@{@"installment available": available,
                                                   @"installment required": required}];
    }
    [self.dueInstallmentConstraint setConstant:0];
    [self.dueInstallmentBorderView setHidden:YES];
    NSNumber *installmentTerm = self.result.additionalData[@"installment_term"];
    if (installmentTerm) {
        self.dueInstallmentLabel.text = [NSString stringWithFormat:@"%@", installmentTerm];
        [self.dueInstallmentBorderView setHidden:NO];
        [self.dueInstallmentConstraint setConstant:45];
    }
    MidtransTransactionDetails *trxDetail = self.token.transactionDetails;
    switch (self.statusType) {
        case SNPStatusTypeError: {
            [[SNPUITrackingManager shared] trackEventName:@"pg error" additionalParameters:additionalData];
            self.title = [VTClassHelper getTranslationFromAppBundleForString:@"payment.failed"];
            self.amountLabel.text = trxDetail.grossAmount.formattedCurrencyNumber;
            self.statusIconView.image = [UIImage imageNamed:@"cross" inBundle:VTBundle compatibleWithTraitCollection:nil];
            self.titleLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Ouch!"];
            self.descriptionLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Your payment can't be processed"];
            
            [self setGradientLayerColors:@[snpRGB(11, 174, 221), snpRGB(212, 56, 92)]];
            break;
        }
            
        case SNPStatusTypeSuccess: {
            [[SNPUITrackingManager shared] trackEventName:@"pg success" additionalParameters:additionalData];
            self.title = [VTClassHelper getTranslationFromAppBundleForString:@"payment.success"];
            self.amountLabel.text = self.result.grossAmount.formattedCurrencyNumber;
            
            self.statusIconView.image = [UIImage imageNamed:@"check" inBundle:VTBundle compatibleWithTraitCollection:nil];
            self.titleLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Thank you!"];
            self.descriptionLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Your payment has been processed"];
            
            [self setGradientLayerColors:@[snpRGB(11, 174, 221), snpRGB(139, 197, 63)]];
            break;
        }
            
        case SNPStatusTypePending: {
            [[SNPUITrackingManager shared] trackEventName:@"pg pending" additionalParameters:additionalData];
            self.title = [VTClassHelper getTranslationFromAppBundleForString:@"payment.pending"];
            self.amountLabel.text = self.result.grossAmount.formattedCurrencyNumber;
            self.statusIconView.image = [UIImage imageNamed:@"pending" inBundle:VTBundle compatibleWithTraitCollection:nil];
            self.titleLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Thank you!"];
            self.descriptionLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Please complete payment to proceed"];
            
            [self setGradientLayerColors:@[snpRGB(11, 174, 221), snpRGB(250, 175, 63)]];
            break;
        }
        case SNPStatusTypeDeny: {
            [[SNPUITrackingManager shared] trackEventName:@"pg deny" additionalParameters:additionalData];
            self.title = [VTClassHelper getTranslationFromAppBundleForString:@"payment.deny"];
            self.amountLabel.text = self.result.grossAmount.formattedCurrencyNumber;
            self.statusIconView.image = [UIImage imageNamed:@"pending" inBundle:VTBundle compatibleWithTraitCollection:nil];
            self.titleLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"payment.deny"];
            self.descriptionLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"message.payment.deny"];
            
            [self setGradientLayerColors:@[snpRGB(11, 174, 221), snpRGB(212, 56, 92)]];
            break;
        }
    }
    
    self.orderIdLabel.text = trxDetail.orderId;
    self.paymentTypeLabel.text = self.paymentMethod.title;
    
    [self.finishButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"] forState:UIControlStateNormal];
}

- (void)setGradientLayerColors:(NSArray <UIColor*>*)colors {
    self.gradientLayer = [CAGradientLayer layer];
    NSMutableArray *cgcolors = [NSMutableArray new];
    for (UIColor *color in colors) {
        [cgcolors addObject:(id)color.CGColor];
    }
    self.gradientLayer.colors = cgcolors;
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.gradientLayer.frame = self.view.bounds;
}

- (IBAction)finishPressed:(UIButton *)sender {
    switch (self.statusType) {
        case SNPStatusTypeError: {
            
            [self dismissViewControllerAnimated:YES completion:^{
                NSDictionary *userInfo = @{TRANSACTION_ERROR_KEY:self.error};
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_FAILED object:nil userInfo:userInfo];
            }];
            break;
        }
        case SNPStatusTypeSuccess: {
            [self dismissViewControllerAnimated:YES completion:^{
                NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_SUCCESS object:nil userInfo:userInfo];
            }];
            break;
        }
        case SNPStatusTypePending: {
            [self dismissViewControllerAnimated:YES completion:^{
                NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
            }];
            break;
        }
        case SNPStatusTypeDeny: {
            [self dismissViewControllerAnimated:YES completion:^{
                NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_DENY object:nil userInfo:userInfo];
            }];
            break;
        }
    }
}

@end
