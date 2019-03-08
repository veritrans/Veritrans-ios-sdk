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
#import "MidtransTransactionDetailViewController.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransUIThemeManager.h"
#import "MIDConstants.h"
#import "MID3DSController.h"
#import "MIDUIModelHelper.h"

@interface SNPPointViewController ()<UITextFieldDelegate, MID3DSControllerDelegate>
@property (strong, nonatomic) IBOutlet SNPPointView *view;
@property (nonatomic,strong) NSString *creditCardToken;
//@property (nonatomic) NSMutableArray *maskedCards;
@property (nonatomic,strong)MIDPointResponse *pointResponse;
@property (nonatomic) NSInteger attemptRetry;
@property (nonatomic) BOOL savedCard;
//@property (nonatomic,strong) MidtransPaymentCreditCard *transaction;
@property (nonatomic,strong) NSMutableArray *pointRedeem;
@property (nonatomic,strong) NSString *point;
@property (nonatomic) NSInteger currentPoint;
@end

@implementation SNPPointViewController
@dynamic view;

-(instancetype _Nonnull)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod cardToken:(NSString *)cardToken {
    if (self = [super initWithPaymentMethod:paymentMethod]) {
        self.creditCardToken = cardToken;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.point = @"0";
    self.currentPoint = 0;
    self.view.pointBankImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_badge",self.bankName] inBundle:VTBundle compatibleWithTraitCollection:nil];
    self.view.pointBankImage.contentMode = UIViewContentModeScaleAspectFit;

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
    [self.view configureAmountTotal:self.info];
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Calculating your Point"]];
    
    [MIDCreditCardCharge getPointWithToken:self.snapToken cardToken:self.creditCardToken completion:^(MIDPointResponse * _Nullable result, NSError * _Nullable error) {
        if (!error) {
            self.currentPoint = [result.balanceAmount intValue];
            
            self.view.pointInputTextField.text = [NSString stringWithFormat:@"%i",[result.balanceAmount intValue]];
            if ([self.bankName isEqualToString:SNP_CORE_BANK_BNI]) {
                self.view.pointTotalTtitle.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"Your total BNI Reward Points is %i"],[result.balanceAmount intValue]];
                self.view.topTextfield.hidden = YES;
                
            } else {
                self.view.topTextfield.hidden = NO;
                self.view.pointTotalTtitle.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"Current fiesta point %i"],[result.balanceAmount intValue]];
                self.view.topTextfield.text = [NSNumber numberWithInteger:0 - [result.balanceAmount integerValue]].formattedCurrencyNumber;
            }
            
            [self updatePoint:[NSString stringWithFormat:@"%ld",(long)[result.balanceAmount intValue]]];
            [self hideLoading];
        }
    }];
    
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.view.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.info.items withChangedGrossAmount:self.view.totalAmountPriceLabel.text pointName:self.title pointValue:self.currentPoint];
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
    if ([amount integerValue]  <= [self.pointResponse.balanceAmount intValue]) {
        NSInteger grossAmount = [self.info.transaction.grossAmount intValue] - [amount integerValue];
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

- (IBAction)submitPaymentWithToken:(id)sender {
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    
    if (self.secureURL.length) {
        MID3DSController *vc = [[MID3DSController alloc] initWithURL:[NSURL URLWithString:self.secureURL]];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        [self executeTransaction];
    }
}
- (IBAction)payWithoutPointButton:(id)sender {
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    
    self.point = @"0";
    
    if (self.secureURL.length) {
        MID3DSController *vc = [[MID3DSController alloc] initWithURL:[NSURL URLWithString:self.secureURL]];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        [self executeTransaction];
    }
}

- (void)secureAuthenticationSuccess:(MID3DSController *)viewController {
    [self executeTransaction];
}

- (void)secureAuthenticationRBASuccess:(MID3DSController *)viewController {}

- (void)secureAuthenticationError:(MID3DSController *)viewController error:(NSError *)error {
    [self handleTransactionError:error];
}

- (void)executeTransaction {
    [MIDCreditCardCharge chargeWithToken:self.snapToken
                               cardToken:self.creditCardToken
                                    save:self.isSaveCard
                             installment:nil
                                   point:@([self.point integerValue])
                                   promo:nil
                              completion:^(MIDCreditCardResult * _Nullable result, NSError * _Nullable error)
     {
         [self hideLoading];
         if (error) {
             
             
             UIAlertController *alertController = [UIAlertController
                                                   alertControllerWithTitle:@"ERROR"
                                                   message:error.localizedMidtransErrorMessage
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
             if ([result.fraudStatus isEqualToString:@"challenge"]) {
                 [self handleTransactionResult:result];
             }
             else {
                 if ([result.transactionStatus isEqualToString:MIDTRANS_TRANSACTION_STATUS_DENY] && self.attemptRetry<2) {
                     self.attemptRetry+=1;
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                     message:[VTClassHelper getTranslationFromAppBundleForString:[result codeForLocalization]]
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
