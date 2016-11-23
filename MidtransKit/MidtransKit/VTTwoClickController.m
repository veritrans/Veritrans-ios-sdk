//
//  VTTwoClickController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/4/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTTwoClickController.h"
#import "VTCardListController.h"
#import "MidtransUITextField.h"
#import "VTClassHelper.h"
#import "VTCCBackView.h"
#import "MidtransUICCFrontView.h"

#import "PopAnimator.h"

#import <MidtransCoreKit/MidtransCoreKit.h>

#import "VTPaymentStatusViewModel.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "IHKeyboardAvoiding_vt.h"

@interface VTTwoClickController () <UINavigationControllerDelegate>

@property (nonatomic) IBOutlet MidtransUITextField *cvvTextField;
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
    [self showLoadingWithText:@"Processing your transaction"];
    MidtransTokenizeRequest *tokenRequest = [[MidtransTokenizeRequest alloc] initWithTwoClickToken:self.maskeCard.savedTokenId
                                                                                               cvv:self.cvvTextField.text
                                                                                       grossAmount:self.token.transactionDetails.grossAmount];
    
    [[MidtransClient shared] generateToken:tokenRequest
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
    [self hideLoading];
}

- (void)handleTransactionError:(NSError *)error {
    [super handleTransactionError:error];
    [self hideLoading];
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
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard modelWithToken:token customer:self.token.customerDetails saveCard:NO];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:self.token];
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

@end
