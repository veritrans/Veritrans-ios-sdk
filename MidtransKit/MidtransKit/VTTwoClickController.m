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

#import <MidtransCoreKit/VTClient.h>
#import <MidtransCoreKit/VTMerchantClient.h>
#import <MidtransCoreKit/VTPaymentCreditCard.h>
#import <MidtransCoreKit/VTTokenizeRequest.h>
#import <MidtransCoreKit/VT3DSController.h>

#import "VTHudView.h"
#import "VTPaymentStatusViewModel.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "IHKeyboardAvoiding_vt.h"
#import "VTKeyboardAccessoryView.h"

@interface VTTwoClickController () <UINavigationControllerDelegate>

@property (nonatomic) IBOutlet VTTextField *cvvTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *fieldScrollView;
@property (nonatomic) NSString *savedToken;
@property (nonatomic) VTKeyboardAccessoryView *keyboardAccessoryView;

@end

@implementation VTTwoClickController {
    VTHudView *_hudView;
}

- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray<VTItemDetail *> *)itemDetails transactionDetails:(VTTransactionDetails *)transactionDetails savedToken:(NSString *)savedToken {
    self = [super initWithCustomerDetails:customerDetails itemDetails:itemDetails transactionDetails:transactionDetails];
    if (self) {
        self.savedToken = savedToken;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [IHKeyboardAvoiding_vt setAvoidingView:_fieldScrollView];
    
    _hudView = [[VTHudView alloc] init];
    
    _keyboardAccessoryView = [[VTKeyboardAccessoryView alloc] initWithFrame:CGRectZero fields:@[_cvvTextField]];
    
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_cvvTextField becomeFirstResponder];
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
    [_hudView showOnView:self.view];
    
    VTTokenizeRequest *tokenRequest = [[VTTokenizeRequest alloc] initWithTwoClickToken:_savedToken cvv:_cvvTextField.text grossAmount:self.transactionDetails.grossAmount];
    
    [[VTClient sharedClient] generateToken:tokenRequest completion:^(NSString *token, NSString *redirectURL, NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        } else {
            if (redirectURL) {
                VT3DSController *secureController = [[VT3DSController alloc] initWithToken:token
                                                                                 secureURL:[NSURL URLWithString:redirectURL]];
                [secureController showWithCompletion:^(NSError *error) {
                    if (error) {
                        [self handleTransactionError:error];
                    } else {
                        [self payWithToken:token];
                    }
                }];
            } else {
                [self payWithToken:token];
            }
        }
    }];
}

- (void)handleTransactionSuccess:(VTTransactionResult *)result {
    [super handleTransactionSuccess:result];
    [_hudView hide];
}

- (void)handleTransactionError:(NSError *)error {
    [super handleTransactionError:error];
    [_hudView hide];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_cvvTextField]) {
        return [textField filterCvvNumber:string range:range isAmex:NO];
    } else {
        return YES;
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    VTPaymentCreditCard *paymentDetail = [[VTPaymentCreditCard alloc] initWithFeature:VTCreditCardPaymentFeatureOneClick token:token];
    VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetail transactionDetails:self.transactionDetails customerDetails:self.customerDetails itemDetails:self.itemDetails];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
