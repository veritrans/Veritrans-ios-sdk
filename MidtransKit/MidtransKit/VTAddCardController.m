//
//  VTAddCardController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTAddCardController.h"
#import "VTClassHelper.h"
#import "MidtransUITextField.h"
#import "VTCvvInfoController.h"
#import "MidtransUICCFrontView.h"
#import "VTCCBackView.h"
#import "MidtransUICardFormatter.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "IHKeyboardAvoiding_vt.h"
#import "UIViewController+Modal.h"
#import "MidtransUIThemeManager.h"
#import "VTCCBackView.h"
#import "VTAddCardView.h"
#import "MidtransLoadingView.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransUIConfiguration.h"

#if __has_include(<CardIO/CardIO.h>)
#import <CardIO/CardIO.h>
@interface VTAddCardController () <CardIOPaymentViewControllerDelegate>
#else
@interface VTAddCardController ()
#endif

@property (strong, nonatomic) IBOutlet VTAddCardView *view;
@property (strong, nonatomic) IBOutlet UIView *didYouKnowView;
@property (nonatomic) NSMutableArray *maskedCards;
@property (nonatomic) NSInteger attemptRetry;

@end

@implementation VTAddCardController

@dynamic view;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token maskedCards:(NSMutableArray *)maskedCards {
    if (self = [super initWithToken:token]) {
        self.maskedCards = maskedCards;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.attemptRetry = 0;
    self.title = UILocalizedString(@"creditcard.input.title", nil);
    
    [self addNavigationToTextFields:@[self.view.cardNumber, self.view.cardExpiryDate, self.view.cardCvv]];
    
    if ([CC_CONFIG paymentType] == MTCreditCardPaymentTypeNormal) {
        self.view.saveCardView.hidden = YES;
        self.view.saveCardViewHeight.constant = 0;
    }
    else {
        self.view.saveCardView.hidden = NO;
        self.view.saveCardViewHeight.constant = 86;
    }
    
    [self.view setToken:self.token];
    
#if __has_include(<CardIO/CardIO.h>)
    [self.view hideScanCardButton:NO];
    //speedup cardio launch
    [CardIOUtilities preloadCardIO];
#else
    [self.view hideScanCardButton:YES];
#endif
    
    self.didYouKnowView.hidden = UICONFIG.hideDidYouKnowView;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.view.loadingView remove];
}
- (IBAction)cvvInfoPressed:(UIButton *)sender {
    VTCvvInfoController *guide = [[VTCvvInfoController alloc] init];
    [self.navigationController presentCustomViewController:guide onViewController:self.navigationController completion:nil];
}

- (IBAction)registerPressed:(UIButton *)sender {
    MidtransCreditCard *creditCard = [[MidtransCreditCard alloc] initWithNumber:self.view.cardNumber.text
                                                                     expiryDate:self.view.cardExpiryDate.text
                                                                            cvv:self.view.cardCvv.text];
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        [self handleRegisterCreditCardError:error];
        return;
    }
    
    [self.view.loadingView showWithTitle:@"Processing your transaction"];
    
    MidtransTokenizeRequest *tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                                    grossAmount:self.token.transactionDetails.grossAmount
                                                                                         secure:CC_CONFIG.secure3DEnabled];
    
    [[MidtransClient shared] generateToken:tokenRequest
                                completion:^(NSString * _Nullable token, NSError * _Nullable error) {
                                    if (error) {
                                        [self.view.loadingView hide];
                                        [self handleTransactionError:error];
                                    } else {
                                        [self payWithToken:token];
                                    }
                                }];
}

- (void)handleRegisterCreditCardError:(NSError *)error {
    [self.view.loadingView hide];
    
    if ([self.view isViewError:error] == NO) {
        [self showAlertViewWithTitle:@"Error"
                           andMessage:error.localizedDescription
                      andButtonTitle:@"Close"];
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard modelWithToken:token
                                                                                customer:self.token.customerDetails
                                                                                saveCard:self.view.saveCardSwitch.isOn];
    
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
       [self.view.loadingView hide];
        
        if (error) {
            if (self.attemptRetry < 2) {
                self.attemptRetry+=1;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                [self handleTransactionError:error];
            }
        }
        else {
            if (![CC_CONFIG tokenStorageEnabled] && result.maskedCreditCard) {
                [self.maskedCards addObject:result.maskedCreditCard];
                [[MidtransMerchantClient shared] saveMaskedCards:self.maskedCards customer:self.token.customerDetails completion:^(id  _Nullable result, NSError * _Nullable error) {
                    
                }];
            }
            if ([[result.additionalData objectForKey:@"fraud_status"] isEqualToString:@"challenge"]) {
                [self handleTransactionResult:result];
            }
            else {
                if (self.attemptRetry < 2) {
                    self.attemptRetry+=1;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                    message:result.statusMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else {
                 [self handleTransactionSuccess:result];
                }
            }
        }
    }];
}

#if __has_include(<CardIO/CardIO.h>)

- (IBAction)scanCardDidTapped:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.collectCVV = NO;
    scanViewController.collectExpiry = NO;
    scanViewController.hideCardIOLogo = YES;
    [self.navigationController presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.view.cardNumber.text = cardInfo.cardNumber;
    [self.view reformatCardNumber];
    
    self.view.cardCvv.text = cardInfo.cvv;
    
    self.view.cardExpiryDate.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)cardInfo.expiryMonth, (unsigned long)cardInfo.expiryYear];
}

#endif

@end
