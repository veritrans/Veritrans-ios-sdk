//
//  SNPPointViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPointViewController.h"
#import "SNPPointView.h"

#import "MidtransUITextField.h"
#import "VTClassHelper.h"
#import <MidtransCorekit/MidtransCorekit.h>
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
@end

@implementation SNPPointViewController
@dynamic view;
-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nullable)token
                        tokenizedCard:(NSString * _Nonnull)tokenizedCard
                            savedCard:(BOOL)savedCard
         andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response * _Nonnull)responsePayment {
    if (self = [super initWithToken:token]) {
        self.savedCard = savedCard;
        self.creditCardToken = tokenizedCard;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.point = @"0";
    if (self.currentMaskedCards) {
        self.maskedCards = [NSMutableArray arrayWithArray:self.currentMaskedCards];
    }
    else {
        self.maskedCards = [NSMutableArray new];
    }
    self.maskedCards = [NSMutableArray new];
    self.title = @"Redeem BNI Reward Point";
    self.pointRedeem = [NSMutableArray new];
    [self.view configureAmountTotal:self.token];
    [self showLoadingWithText:@"Calculating your Point"];

    [[MidtransMerchantClient shared] requestCustomerPointWithToken:self.token.tokenId
                                                andCreditCardToken:self.creditCardToken
                                                        completion:^(SNPPointResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            self.pointResponse = response;
            self.view.pointInputTextField.text = [NSString stringWithFormat:@"%0ld",[response.pointBalanceAmount integerValue]];
            self.view.pointTotalTtitle.text = [NSString stringWithFormat:@"Your total BNI Reward Points is %ld",[response.pointBalanceAmount integerValue]];
            
            [self updatePoint:[NSString stringWithFormat:@"%ld",(long)[self.pointResponse.pointBalanceAmount integerValue]]];

         [self hideLoading];
        }
    }];

    
    // Do any additional setup after loading the view from its nib.
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
        self.view.finalAmountTextField.text = [NSNumber numberWithInteger:grossAmount].formattedCurrencyNumber;
        return YES;
    }
    else {
        self.point = @"0";
        return NO;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitPaymentWithToken:(id)sender {
    [self showLoadingWithText:@"Processing your transaction"];
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard modelWithToken:self.creditCardToken
                                                                                customer:self.token.customerDetails
                                                                                saveCard:self.savedCard
                                                                                   point:self.point];
    MidtransTransaction *transaction = [[MidtransTransaction alloc]
                                        initWithPaymentDetails:paymentDetail token:self.token];
    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error)
     {
         [self hideLoading];
         if (error) {
             if (self.attemptRetry < 2) {
                 self.attemptRetry += 1;
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

@end
