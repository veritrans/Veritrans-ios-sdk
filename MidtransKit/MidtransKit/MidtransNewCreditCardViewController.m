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
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/MidtransBinResponse.h>
@interface MidtransNewCreditCardViewController () <UITableViewDelegate,UITextFieldDelegate,MidtransPaymentCCAddOnDataSourceDelegate,MidtransUICardFormatterDelegate>
@property (strong, nonatomic) IBOutlet MidtransNewCreditCardView *view;
@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *bottomButton;
@property (nonatomic,strong ) MidtransPaymentCCAddOnDataSource *dataSource;
@property (nonatomic,strong) MidtransPaymentRequestV2CreditCard *creditCardInfo;
@property (nonatomic,strong) MidtransPaymentRequestV2Installment *installment;
@property (nonatomic,strong) MidtransPaymentListModel *paymentMethodInfo;
@property (nonatomic) NSInteger attemptRetry;
@property (nonatomic) MidtransUICardFormatter *ccFormatter;
@property (nonatomic) BOOL saveCard;
@property (nonatomic,strong) NSString *installmentBankName;
@property (nonatomic) NSMutableArray *maskedCards;
@property (nonatomic) NSMutableArray *selectedAddOnIndex;
@property (nonatomic,strong)NSMutableArray *installmentValueObject;
@property (nonatomic) NSArray *bins;
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
    self.selectedAddOnIndex = [NSMutableArray new];
    self.installmentBankName = @"";
    self.view.creditCardNumberTextField.delegate = self;
    self.view.cardExpireTextField.delegate = self;
    self.view.cardCVVNumberTextField.delegate = self;
    self.ccFormatter = [[MidtransUICardFormatter alloc] initWithTextField:self.view.creditCardNumberTextField];
    self.ccFormatter.delegate = self;
    self.ccFormatter.numberLimit = 16;
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
    
    self.bankBinList = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:[VTBundle pathForResource:@"bin" ofType:@"json"]] options:kNilOptions error:nil];
    
    [self.view.addOnTableView registerNib:[UINib nibWithNibName:@"MidtransCreditCardAddOnComponentCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransCreditCardAddOnComponentCell"];
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
    
    if (![self.selectedAddOnIndex containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        [self.selectedAddOnIndex addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    else {
        [self.selectedAddOnIndex removeObject:[NSNumber numberWithInteger:indexPath.row]];
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
    [self matchBINNumberWithInstallment:[self.view.cardCVVNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (self.view.cardCVVNumberTextField.text.length < 1) {
        self.view.cardCVVNumberTextField.infoIcon = nil;
    }
    else {
        NSString *originNumber = [self.view.cardCVVNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.view.cardCVVNumberTextField.infoIcon = [self.view iconDarkWithNumber:originNumber];
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
- (void)matchBINNumberWithInstallment:(NSString *)binNumber {
    if (binNumber.length >= 6) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"SELF['bins'] CONTAINS %@",binNumber];
        NSArray *filtered  = [self.bankBinList filteredArrayUsingPredicate:predicate];
        if (filtered.count) {
            
        }
        else {
          
        }
    }
    
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
-(void)textFieldDidChange :(UITextField *) textField{
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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

@end
