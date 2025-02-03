//
//  VTPaymentGeneralViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MIDUobViewController.h"
#import "MidtransUIPaymentGeneralView.h"
#import "VTClassHelper.h"
#import "UIViewController+HeaderSubtitle.h"
#import "MidtransUIStringHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransTransactionDetailViewController.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransUINextStepButton.h"
#import "MidtransUIThemeManager.h"

@interface MIDUobViewController ()
@property (strong, nonatomic) IBOutlet MidtransUIPaymentGeneralView *view;
@property (nonatomic) MidtransPaymentRequestV2Merchant *merchant;
@property (nonatomic) MidtransTransactionResult *uobTransactionResult;
@end

@implementation MIDUobViewController
@dynamic view;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                     merchant:(MidtransPaymentRequestV2Merchant *)merchant {
    
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        self.merchant = merchant;
    }
    return self;
}

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUobDeeplinkStatus:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [super viewDidLoad];
    [self setupViews];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails grossAmount:self.token.transactionDetails.grossAmount];
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    [self showLoadingWithText:nil];
    
    id<MidtransPaymentDetails>paymentDetails;
    paymentDetails = [[MidtransPaymentUOB alloc] init];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        if (result) {
            if ([self.uobSelectedOption isEqualToString:@"app"]) {
                [self openUobDeeplinkWithResult:result];
            } else {
                [self openUobWebWithResult:result];
            }
        }
        else {
            [self handleTransactionError:error];
        }
    }];
}

- (void)handleUobDeeplinkStatus:(id)sender {
    if ([self.uobSelectedOption isEqualToString:@"app"]) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_CURRENT_TOKEN];
        [[MidtransMerchantClient shared] performCheckStatusTransactionWithToken:token completion:^(MidtransTransactionResult * _Nullable result, NSError * _Nullable error) {
            if (result) {
                if (result.statusCode == 200) {
                    [self handleTransactionSuccess:result];
                }
            } else {
                [self handleTransactionError:error];
            }
        }];
    }
}

- (void)openUobWebWithResult:(MidtransTransactionResult *)result {
    [self handleOpenUob:result];
    [self handleTransactionPending:result];
}

- (void)openUobDeeplinkWithResult:(MidtransTransactionResult *)result {
    [self handleOpenUob:result];
    self.uobTransactionResult = result;
}

- (void)handleOpenUob:(MidtransTransactionResult *)result {
    NSString *uobWebStringURL = [NSString stringWithFormat:@"%@",result.uobEzpayWebUrl];
    if ([self.uobSelectedOption isEqualToString:@"app"]) {
        uobWebStringURL = [NSString stringWithFormat:@"%@",result.uobEzpayDeeplinkUrl];
    }
    NSURL *uobWebURL = [NSURL URLWithString:uobWebStringURL];
    if ([[UIApplication sharedApplication] canOpenURL:uobWebURL]) {
        [[UIApplication sharedApplication] openURL:uobWebURL
                                           options:@{}
                                 completionHandler:nil];
    }
}

- (void)setupViews{
    self.title = self.paymentMethod.title;
    self.view.tokenViewConstraints.constant = 0.0f;
    self.view.topConstraints.constant = 0.0f;
    [self updateViewConstraints];
    
    [self setupInstructions];
    
    self.view.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.view.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
    [self.view.confirmPaymentButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Pay Now"] forState:UIControlStateNormal];
}

- (void)setupInstructions {
    NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.paymentMethod.internalBaseClassIdentifier];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.internalBaseClassIdentifier] ofType:@"plist"];
    }
    
    if (self.uobSelectedOptionTitle) {
        self.title = self.uobSelectedOptionTitle;
        if (self.uobSelectedOption) {
            filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@_%@", self.paymentMethod.internalBaseClassIdentifier, self.uobSelectedOption];
            guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
            if (guidePath == nil) {
                guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@_%@",self.paymentMethod.internalBaseClassIdentifier, self.uobSelectedOption] ofType:@"plist"];
            }
        }
    }
    
    NSArray *instructions = [VTClassHelper instructionsFromFilePath:guidePath];
    self.view.guideView.instructions = instructions;
}

- (void)backButtonDidTapped:(id)sender {
    
    if (self.uobTransactionResult) {
        NSString *title;
        NSString *content;
        title = [VTClassHelper getTranslationFromAppBundleForString:@"Finish Payment"];
        content = [VTClassHelper getTranslationFromAppBundleForString:@"Make sure payment has been completed within the UOB app."];
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:content
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
            NSLog(@"Cancel action");
        }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.uobTransactionResult};
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
            }];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
