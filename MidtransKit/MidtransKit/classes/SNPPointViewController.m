//
//  SNPPointViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPointViewController.h"
#import "SNPPointView.h"
#import "MidtransUINextStepButton.h"
#import "MidtransUITextField.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransTransactionDetailViewController.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransUIThemeManager.h"

@interface SNPPointViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet SNPPointView *view;
@property (nonatomic,strong) NSString *creditCardToken;
@property (nonatomic) NSMutableArray *maskedCards;
@property (nonatomic,strong)SNPPointResponse *pointResponse;
@property (nonatomic) NSInteger attemptRetry;
@property (nonatomic) BOOL savedCard;
@property (nonatomic,strong) MidtransPaymentCreditCard *transaction;
@property (nonatomic,strong) NSMutableArray *pointRedeem;
@property (nonatomic,strong) NSString *point;
@property (nonatomic) NSInteger currentPoint;
@end

@implementation SNPPointViewController
@dynamic view;
-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nullable)token
                        paymentMethod:(MidtransPaymentListModel *_Nullable)paymentMethod
                        tokenizedCard:(NSString * _Nonnull)tokenizedCard
                            savedCard:(BOOL)savedCard
         andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response * _Nonnull)responsePayment {
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        self.savedCard = savedCard;
        self.creditCardToken = tokenizedCard;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.point = @"0";
    self.currentPoint = 0;
     self.view.pointBankImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_badge",self.bankName] inBundle:VTBundle compatibleWithTraitCollection:nil];
    self.view.pointBankImage.contentMode = UIViewContentModeScaleAspectFit;
    if (self.currentMaskedCards) {
        self.maskedCards = [NSMutableArray arrayWithArray:self.currentMaskedCards];
    }
    else {
        self.maskedCards = [NSMutableArray new];
    }
    self.maskedCards = [NSMutableArray new];
    if ([self.bankName isEqualToString:SNP_CORE_BANK_BNI]) {
        self.view.paymentWithoutPointButton.hidden = YES;
        self.view.pointInputTextField.placeholder = [VTClassHelper getTranslationFromAppBundleForString:@"bni.point.toptitle"];
        
        self.view.pointTopTile.text = [VTClassHelper getTranslationFromAppBundleForString:@"bni.point.toptitle"];
        
        self.view.pointBottomTitle.text = [VTClassHelper getTranslationFromAppBundleForString:@"bni.point.secondtitle"];
        
        self.view.payWithoutPointHeightConstraints.constant = 0.0f;
        self.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.Redeem BNI Reward Point"];
    }
    else {
        self.title = @"Mandiri Fiestapoin";
        [self.view.paymentWithoutPointButton setTitle: [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.Pay Without Mandiri Point"] forState:UIControlStateNormal];
        
        self.view.topTextLabel.hidden = NO;
        self.view.topTextLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Diskon Fiesta Point"];
        self.view.pointInputTextField.hidden = YES;
    }
    self.pointRedeem = [NSMutableArray new];
    [self.view configureAmountTotal:self.token];
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Calculating your Point"]];

    [[MidtransMerchantClient shared] requestCustomerPointWithToken:self.token.tokenId
                                                andCreditCardToken:self.creditCardToken
                                                        completion:^(SNPPointResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            self.currentPoint = [response.pointBalanceAmount intValue];
            self.pointResponse = response;
            self.view.pointInputTextField.text = [NSString stringWithFormat:@"%i",[response.pointBalanceAmount intValue]];
            if ([self.bankName isEqualToString:SNP_CORE_BANK_BNI]) {
                self.view.pointTotalTtitle.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"Your total BNI Reward Points is %i"],[response.pointBalanceAmount intValue]];
                self.view.topTextfield.hidden = YES;
               
            } else {
                 self.view.topTextfield.hidden = NO;
                self.view.pointTotalTtitle.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"Current fiesta point %i"],[response.pointBalanceAmount intValue]];
                self.view.topTextfield.text = [NSNumber numberWithInteger:0 - [response.pointBalanceAmount integerValue]].formattedCurrencyNumber;
            }
           
            [self updatePoint:[NSString stringWithFormat:@"%ld",(long)[self.pointResponse.pointBalanceAmount intValue]]];
            [self hideLoading];
        }
    }];
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.view.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails withChangedGrossAmount:self.view.totalAmountPriceLabel.text pointName:self.title pointValue:self.currentPoint];
}
- (BOOL)textField:(MidtransUITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isKindOfClass:[MidtransUITextField class]]) {
        ((MidtransUITextField *) textField).warning = nil;
    }
    
    if ([textField isEqual:self.view.pointInputTextField]) {
        return  [self updatePoint:[textField.text stringByReplacingCharactersInRange:range withString:string]];

    }
    else {
        return YES;
    }
}
- (BOOL)updatePoint:(NSString *)amount{
    if ([amount integerValue]  <= [self.pointResponse.pointBalanceAmount intValue]) {
        NSInteger grossAmount = [self.token.transactionDetails.grossAmount intValue] - [amount integerValue];
        self.point = [NSString stringWithFormat:@"%ld",(long)[amount integerValue]];
        self.currentPoint =[amount integerValue];
        self.view.finalAmountTextField.text = [NSNumber numberWithInteger:grossAmount].formattedCurrencyNumber;
        self.view.totalAmountPriceLabel.text =[NSNumber numberWithInteger:grossAmount].formattedCurrencyNumber;
        return YES;
    }
    else {
        self.currentPoint = 0;
        self.point = @"0";
        return NO;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitPaymentWithToken:(id)sender {
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    if (self.redirectURL.length) {
        Midtrans3DSController *secureController = [[Midtrans3DSController alloc] initWithToken:self.creditCardToken
                                                                                     secureURL:[NSURL URLWithString:self.redirectURL]];
        [secureController showWithCompletion:^(NSError *error) {
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self executeTransaction:NO];
            }
        }];
    } else {
        [self executeTransaction:NO];
    }
}
- (IBAction)payWithoutPointButton:(id)sender {
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    if (self.redirectURL.length) {
        Midtrans3DSController *secureController = [[Midtrans3DSController alloc] initWithToken:self.creditCardToken
                                                                                     secureURL:[NSURL URLWithString:self.redirectURL]];
        [secureController showWithCompletion:^(NSError *error) {
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self executeTransaction:YES];
            }
        }];
    } else {
        [self executeTransaction:YES];
    }
}
- (void)executeTransaction:(BOOL)withoutPoint {
    if (withoutPoint) {
        self.point = @"0";
    }
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard modelWithToken:self.creditCardToken
                                                                                customer:self.token.customerDetails
                                                                                saveCard:self.savedCard
                                                                                   point:self.point];
    MidtransTransaction *transaction = [[MidtransTransaction alloc]
                                        initWithPaymentDetails:paymentDetail
                                        token:self.token];
    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error)
     {
         [self hideLoading];
         if (error) {

             
             UIAlertController *alertController = [UIAlertController
                                                   alertControllerWithTitle:@"ERROR"
                                                   message:error.localizedDescription
                                                   preferredStyle:UIAlertControllerStyleAlert];

             UIAlertAction *okAction = [UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                            
                                            [self.navigationController popViewControllerAnimated:YES];
                                            
                                        }];
             
             [alertController addAction:okAction];
             [self presentViewController:alertController animated:YES completion:nil];
         }
         else {
             if (![CC_CONFIG tokenStorageEnabled] && result.maskedCreditCard) {
                 [self.maskedCards addObject:result.maskedCreditCard];
                 [[MidtransMerchantClient shared] saveMaskedCards:self.maskedCards
                                                         customer:self.token.customerDetails
                                                       completion:^(id  _Nullable result, NSError * _Nullable error) {
                                                           
                                                       }];
             }
             if ([[result.additionalData objectForKey:@"fraud_status"] isEqualToString:@"challenge"]) {
                 [self handleTransactionResult:result];
             }
             else {
                 if ([result.transactionStatus isEqualToString:MIDTRANS_TRANSACTION_STATUS_DENY] && self.attemptRetry<2) {
                     self.attemptRetry+=1;
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                     message:result.statusMessage
                                                                    delegate:nil
                                                           cancelButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
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
@end
