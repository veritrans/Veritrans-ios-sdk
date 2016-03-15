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

#import "VTHudView.h"
#import "VTPaymentStatusViewModel.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"

@interface VTTwoClickController () <UINavigationControllerDelegate>
@property (nonatomic) IBOutlet VTTextField *cvvTextField;
@property (strong, nonatomic) IBOutlet UIView *navigationView;

@property (nonatomic) VTCustomerDetails *customer;
@property (nonatomic) NSArray *items;
@property (nonatomic) NSString *savedTokenId;

@end

@implementation VTTwoClickController {
    VTHudView *_hudView;
}

+ (instancetype)controllerWithCustomer:(VTCustomerDetails *)customer items:(NSArray *)items savedTokenId:(NSString *)savedTokenId {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTTwoClickController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTTwoClickController"];
    vc.customer = customer;
    vc.items = items;
    vc.savedTokenId = savedTokenId;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _hudView = [[VTHudView alloc] init];
    
    _cvvTextField.inputAccessoryView = _navigationView;
    
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

- (IBAction)donePressed:(UIButton *)sender {
    [self.view endEditing:YES];
}

- (IBAction)paymentPressed:(UIButton *)sender {
    [_hudView showOnView:self.view];
    
    VTTokenRequest *tokenRequest = [VTTokenRequest tokenForTwoClickTransactionWithToken:_savedTokenId
                                                                                    cvv:_cvvTextField.text
                                                                                 secure:NO
                                                                            grossAmount:[_items itemsPriceAmount]];
    
    [[VTClient sharedClient] generateToken:tokenRequest completion:^(NSString *token, NSError *error) {
        if (token) {
            VTPaymentCreditCard *payDetail = [VTPaymentCreditCard paymentForTokenId:token];
            VTCTransactionDetails *transDetail = [[VTCTransactionDetails alloc] initWithGrossAmount:[_items itemsPriceAmount]];
            VTCTransactionData *transData = [[VTCTransactionData alloc] initWithpaymentDetails:payDetail
                                                                            transactionDetails:transDetail
                                                                               customerDetails:_customer
                                                                                   itemDetails:_items];
            
            [[VTMerchantClient sharedClient] performCreditCardTransaction:transData completion:^(id response, NSError *error) {
                [_hudView hide];
                
                if (response) {
                    VTPaymentStatusViewModel *vm = [VTPaymentStatusViewModel viewModelWithData:response];
                    VTSuccessStatusController *vc = [VTSuccessStatusController controllerWithSuccessViewModel:vm];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    VTErrorStatusController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTErrorStatusController"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
        else {
            [_hudView hide];
            
            VTErrorStatusController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTErrorStatusController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_cvvTextField]) {
        return [textField filterCvvNumber:string range:range];
    } else {
        return YES;
    }
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
