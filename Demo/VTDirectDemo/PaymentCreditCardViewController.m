//
//  PaymentCreditCardViewController.m
//  VTDirectDemo
//
//  Created by Arie on 8/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "PaymentCreditCardViewController.h"
#import <MBProgressHUD.h>
#import "PaymentCreditCardView.h"
#import <SRMonthPicker.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransPaymentListModel.h>
@interface PaymentCreditCardViewController () <UITextFieldDelegate>
@property (nonatomic,strong) NSString *previousTextFieldContent;
@property (nonatomic,strong) UITextRange *previousSelection;
@property (weak, nonatomic) IBOutlet PaymentCreditCardView *view;
@end

@implementation PaymentCreditCardViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Credit Card";
    [self.view.creditcardTextField addTarget:self
                      action:@selector(reformatAsCardNumber:)
            forControlEvents:UIControlEventEditingChanged];
    [self.view.validDateTextField addTarget:self
                   action:@selector(dateTextFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)payNowDidTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSArray *dates = [self.view.validDateTextField.text componentsSeparatedByString:@"/"];
    NSString *expMonth = dates[0];
    NSString *expYear = dates.count == 2 ? dates[1] : nil;
    
    MidtransCreditCard *creditCard = [[MidtransCreditCard alloc] initWithNumber:[self.view.creditcardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]
                                                                    expiryMonth:expMonth
                                                                     expiryYear:expYear cvv:self.view.cvvTextField.text];
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"ERROR"
                                  message:error.description
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }

    MidtransTokenizeRequest *tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                                    grossAmount:self.transactionToken.transactionDetails.grossAmount
                                                                                         secure:CC_CONFIG.secure3DEnabled];
    [[MidtransClient shared] generateToken:tokenRequest
                                completion:^(NSString * _Nullable token, NSError * _Nullable error) {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    if (error) {
                                        // create an alert view with three buttons
                                        UIAlertView *alertView = [[UIAlertView alloc]
                                                                  initWithTitle:@"ERROR"
                                                                  message:error.description
                                                                  delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                                        [alertView show];
                                        
                                    } else {
                                        [self payWithToken:token];
                                    }
                                }];
}
- (void)payWithToken:(NSString *)token {
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard modelWithToken:token customer:self.transactionToken.customerDetails saveCard:NO installment:nil];
    
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:self.transactionToken];
    
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        if (error) {
            // create an alert view with three buttons
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"ERROR"
                                      message:error.description
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        } else {
            // create an alert view with three buttons
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"SUCCESS"
                                      message:result
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            
        }
    }];
}
-(void)reformatAsCardNumber:(UITextField *)textField
{
    // In order to make the cursor end up positioned correctly, we need to
    // explicitly reposition it after we inject spaces into the text.
    // targetCursorPosition keeps track of where the cursor needs to end up as
    // we modify the string, and at the end we set the cursor position to it.
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumberWithoutSpaces =
    [self removeNonDigits:textField.text
andPreserveCursorPosition:&targetCursorPosition];
    
    if ([cardNumberWithoutSpaces length] > 16) {
        // If the user is trying to enter more than 19 digits, we prevent
        // their change, leaving the text field in  its previous state.
        // While 16 digits is usual, credit card numbers have a hard
        // maximum of 19 digits defined by ISO standard 7812-1 in section
        // 3.8 and elsewhere. Applying this hard maximum here rather than
        // a maximum of 16 ensures that users with unusual card numbers
        // will still be able to enter their card number even if the
        // resultant formatting is odd.
        [textField setText:self.previousTextFieldContent];
        textField.selectedTextRange = self.previousSelection;
        return;
    }
    
    NSString *cardNumberWithSpaces =
    [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
                      andPreserveCursorPosition:&targetCursorPosition];
    
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition =
    [textField positionFromPosition:[textField beginningOfDocument]
                             offset:targetCursorPosition];
    
    [textField setSelectedTextRange:
     [textField textRangeFromPosition:targetPosition
                           toPosition:targetPosition]
     ];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.view.creditcardTextField) {
        // Note textField's current state before performing the change, in case
        // reformatTextField wants to revert it
        self.previousTextFieldContent = textField.text;
        self.previousSelection = textField.selectedTextRange;
            return YES;
    }

    else if (self.view.validDateTextField) {
        if ([string isEqualToString:@""] && textField.text.length == 3) {
            NSString *dateString = textField.text;
            textField.text =
            [dateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
            
        }
            return YES;
    }
    else {
        if (textField.text.length >= 3 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {return YES;}
    }

}

/*
 Removes non-digits from the string, decrementing `cursorPosition` as
 appropriate so that, for instance, if we pass in `@"1111 1123 1111"`
 and a cursor position of `8`, the cursor position will be changed to
 `7` (keeping it between the '2' and the '3' after the spaces are removed).
 */
- (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

/*
 Inserts spaces into the string to format it as a credit card number,
 incrementing `cursorPosition` as appropriate so that, for instance, if we
 pass in `@"111111231111"` and a cursor position of `7`, the cursor position
 will be changed to `8` (keeping it between the '2' and the '3' after the
 spaces are added).
 */
- (void) dateTextFieldDidChange: (UITextField *)theTextField {
    NSString *string = theTextField.text;
    if (string.length == 2) {
        theTextField.text = [string stringByAppendingString:@"/"];
        
    } else if (string.length > 5) {
        
        theTextField.text = [string substringToIndex:5];
    }
    
}
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.view.validDateTextField) {
        //[self pickerView:self.monthPickerView didSelectRow:[self.monthPickerView selectedRowInComponent:0] inComponent:0];
    }
}
@end
