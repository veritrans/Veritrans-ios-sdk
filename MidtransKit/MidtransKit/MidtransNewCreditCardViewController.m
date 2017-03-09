//
//  MidtransNewCreditCardViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransNewCreditCardViewController.h"
#import "MidtransNewCreditCardView.h"
#import "MidtransPaymentCCAddOnDataSource.h"
#import "VTClassHelper.h"
#import "MidtransUINextStepButton.h"
#import "SNPPointViewController.h"
#import "UIViewController+Modal.h"
#import "VTCvvInfoController.h"
#import "MidtransUITextField.h"
#import "MidtransUIConfiguration.h"
#import "MidtransUICustomAlertViewController.h"
#import "MidtransUICardFormatter.h"
#import "AddOnConstructor.h"
#import "MidtransInstallmentView.h"
#import "MidtransUITextField.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransBinResponse.h>

@interface MidtransNewCreditCardViewController () <
UITableViewDelegate,
MidtransUITextFieldDelegate,
MidtransPaymentCCAddOnDataSourceDelegate,
MidtransUICardFormatterDelegate,
MidtransInstallmentViewDelegate,
UIAlertViewDelegate
>

@property (strong, nonatomic) IBOutlet MidtransNewCreditCardView *view;
@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *bottomButton;
@property (nonatomic,strong ) MidtransPaymentCCAddOnDataSource *dataSource;
@property (nonatomic,strong) MidtransPaymentRequestV2CreditCard *creditCardInfo;
@property (nonatomic,strong) MidtransPaymentRequestV2Installment *installment;
@property (nonatomic,strong) MidtransPaymentListModel *paymentMethodInfo;
@property (nonatomic) NSInteger attemptRetry;
@property (nonatomic,strong)MidtransInstallmentView *installmentsContentView;
@property (nonatomic) MidtransUICardFormatter *ccFormatter;
@property (nonatomic) BOOL saveCard;
@property (nonatomic,strong) NSString *installmentBankName;
@property (nonatomic) NSMutableArray *maskedCards;
@property (nonatomic,strong)NSMutableArray *installmentValueObject;
@property (nonatomic) NSArray *bins;
@property (nonatomic,strong) MidtransBinResponse *filteredBinObject;
@property (nonatomic) BOOL installmentAvailable,installmentRequired;
@property (nonatomic,strong) NSString *installmentTerms;
@property (nonatomic)NSInteger installmentCurrentIndex;
@property (strong,nonatomic) NSMutableArray *addOnArray;
@property (nonatomic) NSInteger constraintsHeight;
@property (nonatomic,strong)NSArray *bankBinList;
@property (nonatomic) MidtransObtainedPromo *obtainedPromo;
@property (nonatomic) MidtransMaskedCreditCard *maskedCreditCard;
@property (nonatomic) MidtransPaymentRequestV2Response * responsePayment;
@property (nonatomic) BOOL bniPointActive;
@property (nonatomic,strong)AddOnConstructor *constructBNIPoint;
@end

@implementation MidtransNewCreditCardViewController
@dynamic view;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
            andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard
 andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response *)responsePayment {
    if (self = [super initWithToken:token]) {
        self.creditCardInfo = creditCard;
        self.responsePayment = responsePayment;
        self.paymentMethodInfo = paymentMethod;
    }
    return self;
}

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
                   maskedCard:(MidtransMaskedCreditCard *)maskedCard
                   creditCard:(MidtransPaymentRequestV2CreditCard *)creditCard
 andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response *)responsePayment{
    if (self = [super initWithToken:token]) {
        self.maskedCreditCard = maskedCard;
        self.creditCardInfo = creditCard;
        self.responsePayment = responsePayment;
        self.token = token;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = UILocalizedString(@"creditcard.input.title", nil);
    
    if (self.currentMaskedCards) {
        self.maskedCards = [NSMutableArray arrayWithArray:self.currentMaskedCards];
    }
    else {
        self.maskedCards = [NSMutableArray new];
    }
    self.bniPointActive = NO;
    self.installmentCurrentIndex = 0;
    self.installmentAvailable = NO;
    self.installmentValueObject = [NSMutableArray new];
    self.installmentBankName = @"";
    self.view.creditCardNumberTextField.delegate = self;
    self.view.cardCVVNumberTextField.delegate = self;
    self.view.cardExpireTextField.delegate = self;
    [self addNavigationToTextFields:@[self.view.creditCardNumberTextField,self.view.cardExpireTextField,self.view.cardCVVNumberTextField]];
    
    self.ccFormatter = [[MidtransUICardFormatter alloc] initWithTextField:self.view.creditCardNumberTextField];
    self.ccFormatter.numberLimit = 16;
    self.ccFormatter.delegate = self;
    self.addOnArray = [NSMutableArray new];
    self.dataSource = [[MidtransPaymentCCAddOnDataSource alloc] init];
    
    self.dataSource.delegate = self;
    self.view.addOnTableView.dataSource  = self.dataSource;
    [self.view configureAmountTotal:self.token];
    
    self.saveCard = NO;
    self.constructBNIPoint = [[AddOnConstructor alloc]
                                           initWithDictionary:@{@"addOnName":SNP_CORE_BNI_POINT,
                                                                @"addOnTitle":@"Redeem BNI Reward Point"}];
    
    if ([CC_CONFIG saveCardEnabled] && (self.maskedCreditCard == nil)) {
        AddOnConstructor *constructSaveCard = [[AddOnConstructor alloc]
                                               initWithDictionary:@{@"addOnName":SNP_CORE_CREDIT_CARD_SAVE,
                                                                    @"addOnTitle":@"Save card for later use"}];
        if (![self.addOnArray containsObject:constructSaveCard]) {
            self.saveCard = YES;
            [self.addOnArray insertObject:constructSaveCard atIndex:0];
            [self updateAddOnContent];
            [self setCreditCardSelectedAtIndex:0];
           
        }
    }
    
    self.installment = [[MidtransPaymentRequestV2Installment alloc]
                        initWithDictionary: [[self.creditCardInfo dictionaryRepresentation] valueForKey:@"installment"]];
    
    if (self.installment.terms) {
        self.installmentAvailable = YES;
        self.installmentRequired = self.installment.required;
        [self setupInstallmentView];
    }
    self.bins = self.creditCardInfo.whitelistBins;
    self.bankBinList = [NSJSONSerialization JSONObjectWithData:[[NSData alloc]
                                                                initWithContentsOfFile:[VTBundle pathForResource:@"bin" ofType:@"json"]]
                                                       options:kNilOptions error:nil];
    
    if (self.maskedCreditCard) {
        self.view.creditCardNumberTextField.text = self.maskedCreditCard.formattedNumber;
        self.view.cardExpireTextField.text = @"\u2022\u2022 / \u2022\u2022";
        self.view.creditCardNumberTextField.enabled = NO;
        self.view.cardExpireTextField.enabled = NO;
        [self matchBINNumberWithInstallment:self.maskedCreditCard.maskedNumber];
        [self updatePromoViewWithCreditCardNumber:self.maskedCreditCard.maskedNumber];
        [self updateCreditCardTextFieldInfoWithNumber:self.maskedCreditCard.maskedNumber];
        
        self.view.creditCardNumberTextField.textColor = [UIColor grayColor];
        self.view.cardExpireTextField.textColor = [UIColor grayColor];
        
        //add delete button
        self.view.deleteButton.hidden = NO;
        [self.view.deleteButton setTitle:UILocalizedString(@"Delete Saved Card", nil) forState:UIControlStateNormal];
        [self.view.deleteButton addTarget:self action:@selector(deleteCardPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        self.view.creditCardNumberTextField.enabled = YES;
        self.view.cardExpireTextField.enabled = YES;
        self.view.creditCardNumberTextField.textColor = [UIColor darkTextColor];
        self.view.cardExpireTextField.textColor = [UIColor darkTextColor];
        
        self.view.deleteButton.hidden = YES;
    }
    
    [self.view.addOnTableView registerNib:[UINib nibWithNibName:@"MidtransCreditCardAddOnComponentCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransCreditCardAddOnComponentCell"];
}
- (void)setCreditCardSelectedAtIndex:(NSInteger)index {
    if ([CC_CONFIG setDefaultCreditSaveCardEnabled]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.view.addOnTableView selectRowAtIndexPath:indexPath
                                              animated:NO
                                        scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.view.addOnTableView didSelectRowAtIndexPath:indexPath];
    }
}
- (void)deleteCardPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:UILocalizedString(@"alert.title", nil)
                                                    message:UILocalizedString(@"alert.message-delete-card", nil)
                                                   delegate:self
                                          cancelButtonTitle:UILocalizedString(@"alert.no", nil)
                                          otherButtonTitles:UILocalizedString(@"alert.yes", nil), nil];
    [alert show];
}

- (void)setupInstallmentView {
    self.installmentsContentView = [[VTBundle loadNibNamed:@"MidtransInstallmentView" owner:self options:nil] firstObject];
    self.installmentsContentView.delegate = self;
    self.installmentsContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view.installmentView addSubview:self.installmentsContentView];
    NSDictionary *views = @{@"view":self.installmentsContentView};
    [self.view.installmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:0 views:views]];
    [self.view.installmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:0 views:views]];
    [self.installmentsContentView setupInstallmentCollection];
}

- (void)setPromos:(NSArray<MidtransPromo *> *)promos {
    _promos = [promos sortedArrayUsingComparator:^NSComparisonResult(MidtransPromo *obj1, MidtransPromo *obj2) {
        double amount1 = [self calculateDiscountPromo:obj1];
        double amount2 = [self calculateDiscountPromo:obj2];
        return amount1 < amount2;
    }];
}

- (double)calculateDiscountPromo:(MidtransPromo *)promo {
    double result = 0;
    if ([promo.discountType isEqualToString:@"PERCENTED"]) {
        result = self.token.transactionDetails.grossAmount.doubleValue * (promo.discountAmount/100.);
    }
    else {
        result = promo.discountAmount;
    }
    return result;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        UITableViewCell *cell = [self.dataSource tableView:self.view.addOnTableView
                                     cellForRowAtIndexPath:indexPath];
        [cell updateConstraintsIfNeeded];
        [cell layoutIfNeeded];
        float height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddOnConstructor *constructor = [self.dataSource.paymentAddOnArray objectAtIndex:indexPath.row];
    if ([constructor.addOnName isEqualToString:SNP_CORE_CREDIT_CARD_SAVE]) {
        self.saveCard = !self.saveCard;
    }
    if ([constructor.addOnName isEqualToString:SNP_CORE_BNI_POINT]) {
        self.bniPointActive = !self.bniPointActive;
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddOnConstructor *constructor = [self.dataSource.paymentAddOnArray objectAtIndex:indexPath.row];
    if ([constructor.addOnName isEqualToString:SNP_CORE_CREDIT_CARD_SAVE]) {
        self.saveCard = !self.saveCard;
    }
    if ([constructor.addOnName isEqualToString:SNP_CORE_BNI_POINT]) {
        self.bniPointActive = !self.bniPointActive;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)updateAddOnContent {
    self.dataSource.paymentAddOnArray  = self.addOnArray;
    self.view.addOnTableViewHeightConstraints.constant = self.dataSource.paymentAddOnArray.count * 50;
    [self.view.addOnTableView reloadData];
}

- (void)updatePromoViewWithCreditCardNumber:(NSString *)number {
    MidtransPromo *promo = [self promoFromCreditCardNumber:number];
    if (promo) {
        __weak MidtransNewCreditCardViewController *weakSelf = self;
        [MidtransPromoEngine obtainPromo:promo
                       withPaymentAmount:self.token.transactionDetails.grossAmount
                              completion:^(MidtransObtainedPromo *obtainedPromo, NSError *error)
         {
             if (obtainedPromo) {
                 weakSelf.obtainedPromo = obtainedPromo;
                 UIImage *icon = [UIImage imageNamed:@"ccOfferIcon" inBundle:VTBundle compatibleWithTraitCollection:nil];
                 self.view.creditCardNumberTextField.info3Icon = icon;
             }
             else {
                 self.view.creditCardNumberTextField.info3Icon = nil;
             }
             [self.view.creditCardNumberTextField setNeedsLayout];
             [self.view.creditCardNumberTextField layoutSubviews];
         }];
    }
    else {
        self.view.creditCardNumberTextField.info3Icon = nil;
    }
}

- (void)updateCreditCardTextFieldInfoWithNumber:(NSString *)number {
    self.view.creditCardNumberTextField.info1Icon = [self.view iconDarkWithNumber:number];
    self.view.creditCardNumberTextField.info2Icon = [self.view iconWithBankName:self.filteredBinObject.bank];
}

#pragma mark - VTCardFormatterDelegate

- (void)formatter_didTextFieldChange:(MidtransUICardFormatter *)formatter {
    NSString *originNumber = [self.view.creditCardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self updatePromoViewWithCreditCardNumber:originNumber];
    
    
    [self matchBINNumberWithInstallment:originNumber];
    
    
    [self updateCreditCardTextFieldInfoWithNumber:originNumber];
}
- (void)reformatCardNumber {
    NSString *cardNumber = self.view.cardCVVNumberTextField.text;
    NSString *formatted = [NSString stringWithFormat: @"%@ %@ %@ %@",
                           [cardNumber substringWithRange:NSMakeRange(0,4)],
                           [cardNumber substringWithRange:NSMakeRange(4,4)],
                           [cardNumber substringWithRange:NSMakeRange(8,4)],
                           [cardNumber substringWithRange:NSMakeRange(12,4)]];
    
    self.view.cardCVVNumberTextField.text = formatted;
}

- (IBAction)cvvInfoDidTapped:(id)sender {
    MidtransUICustomAlertViewController *alertView = [[MidtransUICustomAlertViewController alloc]
                                                      initWithTitle:@"What is CVV?"
                                                      message:@"The CVV is a 3 (or 6) digit number security code printed on the back of your card"
                                                      image:@"CreditCardBackSmall"
                                                      delegate:nil
                                                      cancelButtonTitle:nil
                                                      okButtonTitle:@"Ok"];
    
    [self.navigationController presentCustomViewController:alertView
                                          onViewController:self.navigationController
                                                completion:nil];
}

- (void)informationButtonDidTappedWithTag:(NSInteger)index {
    AddOnConstructor *constructor = [self.dataSource.paymentAddOnArray objectAtIndex:index];
    if ([constructor.addOnName isEqualToString:SNP_CORE_CREDIT_CARD_SAVE]) {
        
        MidtransUICustomAlertViewController *alertView = [[MidtransUICustomAlertViewController alloc]
                                                          initWithTitle:@"save card for later reuse"
                                                          message:@"We will securely store your card details so you can reuse theme later"
                                                          image:nil
                                                          delegate:nil
                                                          cancelButtonTitle:nil
                                                          okButtonTitle:@"Ok"];
        
        [self.navigationController presentCustomViewController:alertView
                                              onViewController:self.navigationController
                                                    completion:nil];
    }
    else if ([constructor.addOnName isEqualToString:SNP_CORE_BNI_POINT]){
        MidtransUICustomAlertViewController *alertView = [[MidtransUICustomAlertViewController alloc]
                                                          initWithTitle:@"redeem bni reward point"
                                                          message:@"you can pay partly through the redemption of BNI Reward Point through your Credit Card"
                                                          image:nil
                                                          delegate:nil
                                                          cancelButtonTitle:nil
                                                          okButtonTitle:@"Ok"];
        
        [self.navigationController presentCustomViewController:alertView
                                              onViewController:self.navigationController
                                                    completion:nil];
    }
}

-(void)textFieldDidChange :(MidtransUITextField *) textField{
    if ([textField isEqual:self.view.cardCVVNumberTextField]) {
        [self.ccFormatter updateTextFieldContentAndPosition];
    }
    //your code
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSError *error;
    
    if ([textField isEqual:self.view.cardExpireTextField]) {
        [textField.text isValidExpiryDate:&error];
    }
    else if ([textField isEqual:self.view.cardExpireTextField]) {
        [textField.text isValidCreditCardNumber:&error];
    }
    else if ([textField isEqual:self.view.cardCVVNumberTextField]) {
        [textField.text isValidCVVWithCreditCardNumber:self.view.creditCardNumberTextField.text error:&error];
    }
    
    //show warning if error
    if (error) {
        [self.view isViewableError:error];
    }
}

- (BOOL)textField:(MidtransUITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isKindOfClass:[MidtransUITextField class]]) {
        ((MidtransUITextField *) textField).warning = nil;
    }
    
    if ([textField isEqual:self.view.cardExpireTextField]) {
        return [textField filterCreditCardExpiryDate:string range:range];
    }
    else if ([textField isEqual:self.view.creditCardNumberTextField]) {
        return [self.ccFormatter updateTextFieldContentAndPosition];
    }
    else if ([textField isEqual:self.view.cardCVVNumberTextField]) {
        return [textField filterCvvNumber:string
                                    range:range
                           withCardNumber:self.view.creditCardNumberTextField.text];
    }
    else {
        return YES;
    }
}

- (void)textField_didInfo3Tap:(MidtransUITextField *)textField {
    if ([textField isEqual:self.view.creditCardNumberTextField]) {
        NSString *sponsor = self.obtainedPromo.sponsorName;
        NSString *message = [NSString stringWithFormat:UILocalizedString(@"creditcard.promo-message", nil), @(self.obtainedPromo.discountAmount).formattedCurrencyNumber, sponsor];
        
        MidtransUICustomAlertViewController *alertView = [[MidtransUICustomAlertViewController alloc]
                                                          initWithTitle:UILocalizedString(@"creditcard.promo-title", nil)
                                                          message:message
                                                          image:nil
                                                          delegate:nil
                                                          cancelButtonTitle:nil
                                                          okButtonTitle:@"Ok"];
        
        [self.navigationController presentCustomViewController:alertView
                                              onViewController:self.navigationController
                                                    completion:nil];
    }
}

- (MidtransPromo *)promoFromCreditCardNumber:(NSString *)ccNumber {
    for (MidtransPromo *promo in self.promos) {
        for (NSString *bin in promo.bins) {
            if ([ccNumber containsString:bin]) {
                return promo;
            }
        }
    }
    return nil;
}

- (void)matchBINNumberWithInstallment:(NSString *)binNumber {
    if (binNumber.length >= 6) {
        if (self.installmentValueObject.count) {
            return;
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"SELF['bins'] CONTAINS %@", [binNumber substringToIndex:6]];
        NSArray *filtered  = [self.bankBinList filteredArrayUsingPredicate:predicate];
        BOOL isDebitCard = NO;
        if (filtered.count) {
            if (filtered.count > 1) {
                NSArray *debitCard  = [filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF['bank'] CONTAINS 'debit'"]];
                if (debitCard.count) {
                    MidtransBinResponse *debitCardObject = [[MidtransBinResponse alloc] initWithDictionary:[debitCard firstObject]];
                    if ([debitCardObject.bank containsString:SNP_CORE_BANK_MANDIRI]) {
                        isDebitCard = YES;
                        self.title = @"Mandiri Debit Card";
                        self.filteredBinObject.bank = SNP_CORE_BANK_MANDIRI;
                    } else if([debitCardObject.bank containsString:SNP_CORE_BANK_BNI]){
                        isDebitCard = YES;
                        self.title = @"BNI Card";
                        self.filteredBinObject.bank = SNP_CORE_BANK_BNI;
                    }
                }
                
            }
            else{
                self.filteredBinObject = [[MidtransBinResponse alloc] initWithDictionary:[filtered firstObject]];
                if ([self.filteredBinObject.bank containsString:SNP_CORE_DEBIT_CARD]) {
                    if ([self.filteredBinObject.bank containsString:SNP_CORE_BANK_MANDIRI]) {
                         self.title = @"Mandiri Debit Card";
                         self.filteredBinObject.bank = SNP_CORE_BANK_MANDIRI;
                        
                    }
                    else if([self.filteredBinObject.bank containsString:SNP_CORE_BANK_BNI]){
                        self.title = @"BNI Card";
                        self.filteredBinObject.bank = SNP_CORE_BANK_BNI;
                    }
                    isDebitCard = YES;
                }
                else {
                    if ([self.filteredBinObject.bank isEqualToString:SNP_CORE_BANK_BNI]) {
                       
                        if (![self.addOnArray containsObject:self.constructBNIPoint]) {
                            [self.addOnArray addObject:self.constructBNIPoint];
                            [self updateAddOnContent];
                            [self setCreditCardSelectedAtIndex:0];
                        }
                        
                    }
                }
            }
            
            if (self.installmentAvailable) {
                if (!isDebitCard) {
                    self.installmentBankName = self.filteredBinObject.bank;
                    [self.installmentValueObject setArray:@[@"0"]];
                    [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:self.installmentBankName]];
                    [self showInstallmentView:YES];
                }
            }
        }
        else {
            self.title = UILocalizedString(@"creditcard.input.title", nil);
            if([[self.installment.terms objectForKey:@"offline"] count]){
                if (!isDebitCard) {
                    self.installmentBankName = @"offline";
                    [self.installmentValueObject setArray:@[@"0"]];
                    [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:self.installmentBankName]];
                    [self showInstallmentView:YES];
                }
            }
        }
    }
    else{
        if ([self.addOnArray containsObject:self.constructBNIPoint]) {
            self.bniPointActive = NO;
            [self.addOnArray removeObject:self.constructBNIPoint];
            [self updateAddOnContent];
            [self setCreditCardSelectedAtIndex:0];
        }
       
        
        self.title = UILocalizedString(@"creditcard.input.title", nil);
        self.filteredBinObject.bank = nil;
        self.view.creditCardNumberTextField.info2Icon = nil;
        if (self.installmentValueObject.count > 0) {
            self.installmentCurrentIndex = 0;
            [self.installmentValueObject removeAllObjects];
            [self.installmentsContentView resetInstallmentIndex];
        }
        [self showInstallmentView:NO];
        
    }
    
}

- (void)showInstallmentView:(BOOL)show {
    [UIView transitionWithView:self.view.installmentView
                      duration:1
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.view.installmentView.hidden = !show;
                        [self.installmentsContentView.installmentCollectionView reloadData];
                        [self.installmentsContentView configureInstallmentView:self.installmentValueObject];
                    }
                    completion:NULL];
}

- (IBAction)submitPaymentDidtapped:(id)sender {
    [[MIDTrackingManager shared] trackEventName:@"btn confirm payment"];
    
    if (self.installmentAvailable && self.installmentCurrentIndex !=0 && !self.bniPointActive) {
        self.installmentTerms = [NSString stringWithFormat:@"%@_%@",self.installmentBankName,
                                 [[self.installment.terms  objectForKey:self.installmentBankName] objectAtIndex:self.installmentCurrentIndex -1]];
    }
    
    if (self.installmentRequired && self.installmentCurrentIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"This transaction must use installment"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *cardNumber;
    MidtransCreditCard *creditCard;
    
    if (self.maskedCreditCard) {
        cardNumber = self.maskedCreditCard.maskedNumber;
        
    }
    else {
        creditCard = [[MidtransCreditCard alloc] initWithNumber:self.view.creditCardNumberTextField.text
                                                     expiryDate:self.view.cardExpireTextField.text
                                                            cvv:self.view.cardCVVNumberTextField.text];
        NSError *error = nil;
        if ([creditCard isValidCreditCard:&error] == NO) {
            [self handleRegisterCreditCardError:error];
            return;
        }
        
        cardNumber = creditCard.number;
    }
    
    if (self.bins.count) {
        NSError *error;
        if (![MidtransClient isCreditCardNumber:cardNumber eligibleForBins:self.bins error:&error]) {
            [self handleRegisterCreditCardError:error];
            return;
        }
    }

    MidtransTokenizeRequest *tokenRequest;
    
    if (self.maskedCreditCard) {
        if (!self.view.cardCVVNumberTextField.text.length) {
            self.view.cardCVVNumberTextField.warning = @"CVV is invalid";
            return;
        }
        tokenRequest = [[MidtransTokenizeRequest alloc] initWithTwoClickToken:self.maskedCreditCard.savedTokenId
                                                                          cvv:self.view.cardCVVNumberTextField.text
                                                                  grossAmount:self.token.transactionDetails.grossAmount];
    }
    else {
        tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                               grossAmount:self.token.transactionDetails.grossAmount
                                                                    secure:CC_CONFIG.secure3DEnabled];
    }
        [self showLoadingWithText:@"Processing your transaction"];
    if (self.installmentTerms && self.installmentCurrentIndex !=0) {
        NSInteger installment = [self.installment.terms[self.installmentBankName][self.installmentCurrentIndex-1] integerValue];
        tokenRequest.installment = YES;
        tokenRequest.installmentTerm = @(installment);
    }
    if (self.bniPointActive) {
        tokenRequest.point = YES;
    }
    if (self.obtainedPromo) {
        tokenRequest.obtainedPromo = self.obtainedPromo;
    }
    
    [[MidtransClient shared] generateToken:tokenRequest
                                completion:^(NSString * _Nullable token, NSError * _Nullable error) {
                                    if (error) {
                                        [self hideLoading];
                                        [self handleTransactionError:error];
                                    } else {
                                        [self payWithToken:token];
                                    }
                                }];
}

- (void)payWithToken:(NSString *)token {
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard modelWithToken:token
                                                                                customer:self.token.customerDetails
                                                                                saveCard:self.saveCard
                                                                             installment:self.installmentTerms];
    
    if (self.obtainedPromo) {
        paymentDetail.discountToken = self.obtainedPromo.discountToken;
    }
    MidtransTransaction *transaction = [[MidtransTransaction alloc]
                                        initWithPaymentDetails:paymentDetail token:self.token];
    if (self.bniPointActive) {
        [self hideLoading];
        SNPPointViewController *pointVC = [[SNPPointViewController alloc] initWithToken:self.token tokenizedCard:token savedCard:self.saveCard andCompleteResponseOfPayment:self.responsePayment];
        pointVC.currentMaskedCards = self.currentMaskedCards;
        [self.navigationController pushViewController:pointVC animated:YES];
        return;
    }

    
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

- (void)handleRegisterCreditCardError:(NSError *)error {
    if ([self.view isViewableError:error] == NO) {
        [self showAlertViewWithTitle:@"Error"
                          andMessage:error.localizedDescription
                      andButtonTitle:@"Close"];
    }
}

-(void)installmentSelectedIndex:(NSInteger)index {
    self.installmentCurrentIndex = index;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self showLoadingWithText:nil];
        [[MidtransMerchantClient shared] deleteMaskedCreditCard:self.maskedCreditCard token:self.token completion:^(BOOL success) {
            [self hideLoading];
            
            if (success == NO) {
                return;
            }
            
            NSMutableArray *savedTokensM = self.creditCardInfo.savedTokens.mutableCopy;
            NSUInteger index = [savedTokensM indexOfObjectPassingTest:^BOOL(MidtransPaymentRequestV2SavedTokens *savedToken, NSUInteger idx, BOOL * _Nonnull stop) {
                return [self.maskedCreditCard.savedTokenId isEqualToString:savedToken.token];
            }];
            if (index != NSNotFound) {
                [savedTokensM removeObjectAtIndex:index];
            }
            self.creditCardInfo.savedTokens = savedTokensM;
            
            if ([self.delegate respondsToSelector:@selector(didDeleteSavedCard)]) {
                [self.delegate didDeleteSavedCard];
            }
        }];
    }
    else {
        
    }
}

@end
