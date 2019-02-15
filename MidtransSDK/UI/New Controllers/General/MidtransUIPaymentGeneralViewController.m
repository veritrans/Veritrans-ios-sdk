//
//  VTPaymentGeneralViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentGeneralViewController.h"
#import "MidtransUIPaymentGeneralView.h"
#import "VTClassHelper.h"
#import "UIViewController+HeaderSubtitle.h"
#import "MidtransUIStringHelper.h"
#import "MidtransTransactionDetailViewController.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransUINextStepButton.h"
#import "MidtransUIThemeManager.h"
#import "MIDWebPaymentController.h"

#import "MIDVendorUI.h"

@interface MidtransUIPaymentGeneralViewController () <MIDWebPaymentControllerDelegate, MIDWebPaymentControllerDataSource>
@property (strong, nonatomic) IBOutlet MidtransUIPaymentGeneralView *view;
@property (nonatomic) MIDPaymentDetail *model;
@end

@implementation MidtransUIPaymentGeneralViewController {
    MIDWebPaymentResult *_paymentResult;
}
@dynamic view;

- (MIDPaymentInfo *)info {
    return [MIDVendorUI shared].info;
}

- (instancetype)initWithModel:(MIDPaymentDetail *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.title;
    self.view.tokenViewConstraints.constant = 0.0f;
    self.view.topConstraints.constant = 0.0f;
    
    if (self.model.method == MIDPaymentMethodBRIEpay ||
        self.model.method == MIDPaymentMethodBCAKlikpay) {
        
        if (self.model.method == MIDPaymentMethodBCAKlikpay) {
            self.view.tokenViewLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"SMS Charges may be applied for this payment method"];
            [self.view.tokenViewIcon setImage:[[UIImage imageNamed:@"sms" inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }
        self.view.topConstraints.constant = 40.0f;
        self.view.tokenView.hidden = NO;
        self.view.tokenViewConstraints.constant = 40.0f;
        [self updateViewConstraints];
    }
    
    [self updateViewConstraints];
    NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.model.paymentID];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.model.paymentID] ofType:@"plist"];
    }
    
    NSArray *instructions = [VTClassHelper instructionsFromFilePath:guidePath];
    
    self.view.guideView.instructions = instructions;
    self.view.totalAmountLabel.text = self.info.transaction.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.info.transaction.orderID;
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.view.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.info.items];
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    [self showLoadingWithText:nil];
    
    NSString *snapToken = [MIDVendorUI shared].snapToken;
    
    MIDPaymentMethod method = self.model.method;
    
    if (method == MIDPaymentMethodBCAKlikpay) {
        [MIDDirectDebitCharge bcaKlikPayWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if (method == MIDPaymentMethodMandiriECash) {
        [MIDEWalletCharge mandiriECashWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if (method == MIDPaymentMethodBRIEpay) {
        [MIDDirectDebitCharge briEpayWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if (method == MIDPaymentMethodAkulaku) {
        [MIDCardlessCreditCharge akulakuWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if (method == MIDPaymentMethodCIMBClicks) {
        [MIDDirectDebitCharge cimbClicksWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
    else if (method == MIDPaymentMethodDanamonOnline) {
        [MIDDirectDebitCharge danamonOnlineWithToken:snapToken completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error) {
            [self handlePaymentCompletion:result error:error];
        }];
        
    }
}

- (void)handlePaymentCompletion:(MIDWebPaymentResult *)result error:(NSError *)error {
    _paymentResult = result;
    
    [self hideLoading];
    
    if (error) {
        [self handleTransactionError:error];
    }
    else {
        if (result.redirectURL) {
            MIDWebPaymentController *vc = [[MIDWebPaymentController alloc] initWithPaymentURL:result.redirectURL];
            vc.delegate = self;
            vc.dataSource = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [self handleTransactionSuccess:result];
        }
    }
}

#pragma mark - MIDWebPaymentControllerDelegate

- (void)webPaymentController:(MIDWebPaymentController *)viewController didError:(NSError *)error {
    [self handleTransactionError:error];
}

- (void)webPaymentControllerDidPending:(MIDWebPaymentController *)viewController {
    if (_paymentResult) {
        [self handleTransactionPending:_paymentResult];
    }
}

#pragma mark - MIDWebPaymentControllerDataSource

- (NSString *)headerTitle {
    return self.model.title;
}

- (NSString *)finishedSignText {
    switch (self.model.method) {
        case MIDPaymentMethodCIMBClicks:
            return @"cimb-clicks/response";
            
        case MIDPaymentMethodBCAKlikpay:
            return @"id=";
            
        case MIDPaymentMethodMandiriECash:
            return @"notify";
            
        case MIDPaymentMethodAkulaku:
            return @"akulaku/callback";
            
        case MIDPaymentMethodBRIEpay:
            return @"briPayment";
            
        default:
            return nil;
    }
}

@end
