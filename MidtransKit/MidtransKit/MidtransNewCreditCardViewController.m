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
#import "UIViewController+Modal.h"
#import "VTCvvInfoController.h"
#import "MidtransUITextField.h"
#import "MidtransUIConfiguration.h"
#import "MidtransUICardFormatter.h"
#import "AddOnConstructor.h"
#import "MidtransInstallmentView.h"
#import "MidtransUITextField.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransBinResponse.h>
static dispatch_once_t * onceToken;
@interface MidtransNewCreditCardViewController () <UITableViewDelegate,UITextFieldDelegate,MidtransPaymentCCAddOnDataSourceDelegate,MidtransUICardFormatterDelegate,MidtransInstallmentViewDelegate>
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
@property (nonatomic) NSMutableArray *selectedAddOnIndex;
@property (nonatomic,strong)NSMutableArray *installmentValueObject;
@property (nonatomic) NSArray *bins;
@property (nonatomic,strong) MidtransBinResponse *filteredBinObject;
@property (nonatomic) BOOL installmentAvailable,installmentRequired;
@property (nonatomic,strong) NSString *installmentTerms;
@property (nonatomic)NSInteger installmentCurrentIndex;
@property (strong,nonatomic) NSMutableArray *addOnArray;
@property (nonatomic) NSInteger constraintsHeight;
@property (nonatomic,strong)NSArray *bankBinList;
@end

@implementation MidtransNewCreditCardViewController
@dynamic view;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
            andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard {
    if (self = [super initWithToken:token]) {
        self.creditCardInfo = creditCard;
        self.paymentMethodInfo = paymentMethod;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = UILocalizedString(@"creditcard.input.title", nil);
    self.installmentCurrentIndex = 0;
    self.installmentAvailable = NO;
    self.installmentValueObject = [NSMutableArray new];
    self.selectedAddOnIndex = [NSMutableArray new];
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
    
    if ([CC_CONFIG saveCardEnabled]) {
        AddOnConstructor *constructSaveCard = [[AddOnConstructor alloc]
                                               initWithDictionary:@{@"addOnName":@"CREDIT_CARD_SAVE",
                                                                    @"addOnTitle":@"Save card for later use"}];
        if (![self.addOnArray containsObject:constructSaveCard]) {
            [self.addOnArray addObject:constructSaveCard];
            [self updateAddOnContent];
        }

    }
    self.installment = [[MidtransPaymentRequestV2Installment alloc] initWithDictionary: [[self.creditCardInfo dictionaryRepresentation] valueForKey:@"installment"]];
    if (self.installment.terms) {
        self.installmentAvailable = YES;
        self.installmentRequired = self.installment.required;
        [self setupInstallmentView];
        
    }
    self.bins = self.creditCardInfo.whitelistBins;
    self.bankBinList = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:[VTBundle pathForResource:@"bin" ofType:@"json"]] options:kNilOptions error:nil];
    
    [self.view.addOnTableView registerNib:[UINib nibWithNibName:@"MidtransCreditCardAddOnComponentCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransCreditCardAddOnComponentCell"];
}
- (void)setupInstallmentView {
    self.installmentsContentView = [[VTBundle loadNibNamed:@"MidtransInstallmentView" owner:self options:nil] firstObject];
    self.installmentsContentView.delegate = self;
    [self.view.installmentView  addSubview:self.installmentsContentView];
    [self.installmentsContentView setupInstallmentCollection];
    
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
    if (![self.selectedAddOnIndex containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        [self.selectedAddOnIndex addObject:[NSNumber numberWithInteger:indexPath.row]];
        if ([constructor.addOnName isEqualToString:@"CREDIT_CARD_SAVE"]) {
            self.saveCard = YES;
        }
        //saveCard
    }
    else {
        [self.selectedAddOnIndex removeObject:[NSNumber numberWithInteger:indexPath.row]];
        if ([constructor.addOnName isEqualToString:@"CREDIT_CARD_SAVE"]) {
            self.saveCard = NO;
        }
         //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - VTCardFormatterDelegate

- (void)formatter_didTextFieldChange:(MidtransUICardFormatter *)formatter {
    NSString *originNumber = [self.view.creditCardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self matchBINNumberWithInstallment:originNumber];
    if (self.view.creditCardNumberTextField.text.length < 1) {
        self.view.creditCardNumberTextField.infoIcon = nil;
    }
    else {
        self.view.creditCardNumberTextField.infoIcon = [self.view iconDarkWithNumber:originNumber];
    }
    
   
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
    VTCvvInfoController *guide = [[VTCvvInfoController alloc] init];
    [self.navigationController presentCustomViewController:guide onViewController:self.navigationController completion:nil];
}
- (void)informationButtonDidTappedWithTag:(NSInteger)index {
    AddOnConstructor *constructor = [self.dataSource.paymentAddOnArray objectAtIndex:index];
    if ([constructor.addOnName isEqualToString:@"CREDIT_CARD_SAVE"]) {
        
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
        return [textField filterCvvNumber:string range:range withCardNumber:self.view.creditCardNumberTextField.text];
    }
    else {
        return YES;
    }
}

- (void)matchBINNumberWithInstallment:(NSString *)binNumber {
    static dispatch_once_t once_token;
    onceToken = &once_token;
    if (binNumber.length >= 6) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"SELF['bins'] CONTAINS %@",binNumber];
        NSArray *filtered  = [self.bankBinList filteredArrayUsingPredicate:predicate];
        dispatch_once(&once_token, ^{
            if (filtered.count) {
                self.filteredBinObject = [[MidtransBinResponse alloc] initWithDictionary:[filtered firstObject]];
                if (self.installmentAvailable) {
                    self.installmentBankName = self.filteredBinObject.bank;
                    [self.installmentValueObject addObject:@"0"];
                    [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:self.filteredBinObject.bank]];
                    [self showInstallmentView:YES];
                }
            }
            else {
                if([[self.installment.terms objectForKey:@"offline"] count]){
                    self.installmentBankName = @"offline";
                    [self.installmentValueObject addObject:@"0"];
                    [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:@"offline"]];
                    [self showInstallmentView:YES];
                }

            }
        });
        
    }
    else{
         *onceToken = 0;
        self.filteredBinObject.bank = nil;
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
                        [self.installmentsContentView configureInstallmentView:self.installmentValueObject];
                    }
                    completion:NULL];
}

- (IBAction)submitPaymentDidtapped:(id)sender {
    if (self.installmentAvailable && self.installmentCurrentIndex!=0) {
        self.installmentTerms = [NSString stringWithFormat:@"%@_%@",self.installmentBankName,
                                 [[self.installment.terms  objectForKey:self.installmentBankName] objectAtIndex:self.installmentCurrentIndex -1]];
    }
    if (self.installmentRequired && self.installmentCurrentIndex==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"This transaction must use installment"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    MidtransCreditCard *creditCard = [[MidtransCreditCard alloc] initWithNumber:self.view.creditCardNumberTextField.text
                                                                     expiryDate:self.view.cardExpireTextField.text
                                                                            cvv:self.view.cardCVVNumberTextField.text];
    NSError *error = nil;
    if ([creditCard isValidCreditCard:&error] == NO) {
        [self handleRegisterCreditCardError:error];
        return;
    }
    if (self.bins.count) {
        if (![MidtransClient isCard:creditCard eligibleForBins:self.bins error:&error]) {
            [self handleRegisterCreditCardError:error];
            return;
        }
        
    }
    
    [self showLoadingWithText:@"Processing your transaction"];
    
    MidtransTokenizeRequest *tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                                    grossAmount:self.token.transactionDetails.grossAmount
                                                                                         secure:CC_CONFIG.secure3DEnabled];
    
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
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        
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


@end
