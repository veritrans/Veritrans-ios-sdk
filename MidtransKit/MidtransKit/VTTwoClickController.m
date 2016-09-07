//
//  VTTwoClickController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/4/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTTwoClickController.h"
#import "VTCardListController.h"
#import "VTTextField.h"
#import "VTClassHelper.h"
#import "VTCCBackView.h"
#import "VTCCFrontView.h"

#import "PopAnimator.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

#import "VTPaymentStatusViewModel.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "IHKeyboardAvoiding_vt.h"

@interface VTTwoClickController () <UINavigationControllerDelegate>

@property (nonatomic) IBOutlet VTTextField *cvvTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *fieldScrollView;
@property (nonatomic) MidtransMaskedCreditCard *maskeCard;

@end

@implementation VTTwoClickController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token maskedCard:(MidtransMaskedCreditCard *)maskedCard {
    self = [super initWithToken:token];
    if (self) {
        self.maskeCard = maskedCard;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = UILocalizedString(@"creditcard.twoclick.title", nil);
    [self addNavigationToTextFields:@[self.cvvTextField]];
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.cvvTextField becomeFirstResponder];
    
    [IHKeyboardAvoiding_vt setAvoidingView:self.fieldScrollView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPop)
        return [[PopAnimator alloc] init];
    
    return nil;
}

- (IBAction)paymentPressed:(UIButton *)sender {
    [self showLoadingHud];
    MidtransTokenizeRequest *tokenRequest = [[MidtransTokenizeRequest alloc] initWithTwoClickToken:self.maskeCard.savedTokenId
                                                                                               cvv:self.cvvTextField.text
                                                                                       grossAmount:self.token.transactionDetails.grossAmount];
    
    [[MidtransClient sharedClient] generateToken:tokenRequest
                                      completion:^(NSString * _Nullable token, NSError * _Nullable error) {
                                          if (error) {
                                              [self handleTransactionError:error];
                                          } else {
                                              [self payWithToken:token];
                                          }
                                      }];
}

- (void)handleTransactionSuccess:(MidtransTransactionResult *)result {
    [super handleTransactionSuccess:result];
    [self hideLoadingHud];
}

- (void)handleTransactionError:(NSError *)error {
    [super handleTransactionError:error];
    [self hideLoadingHud];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.cvvTextField]) {
        return [textField filterCvvNumber:string
                                    range:range
                           withCardNumber:self.maskeCard.maskedNumber];
    } else {
        return YES;
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    MidtransPaymentCreditCard *paymentDetail = [[MidtransPaymentCreditCard alloc] initWithFeature:MidtransCreditCardPaymentFeatureOneClick creditCardToken:token token:self.token];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail];
    [[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

@end
