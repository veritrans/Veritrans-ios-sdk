//
//  MidtransNewCreditCardViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransNewCreditCardViewController.h"
#import "MidtransCommonTSCViewController.h"
#import "MidtransNewCreditCardView.h"
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
#import "MidtransCreditCardAddOnComponentCell.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransTransactionDetailViewController.h"
#import "MidtransUIThemeManager.h"

@interface MidtransNewCreditCardViewController () <
UITableViewDelegate,
UITableViewDataSource,
MidtransUITextFieldDelegate,
MidtransUICardFormatterDelegate,
MidtransInstallmentViewDelegate,
Midtrans3DSControllerDelegate,
MidtransCommonTSCViewControllerDelegate,
UIAlertViewDelegate
>

@property (strong, nonatomic) IBOutlet MidtransNewCreditCardView *view;
@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *bottomButton;
@property (nonatomic,strong) MidtransPaymentRequestV2CreditCard *creditCardInfo;
@property (nonatomic,strong) MidtransPaymentRequestV2Installment *installment;
@property (nonatomic,strong) MidtransPaymentListModel *paymentMethodInfo;
@property (nonatomic) NSInteger attemptRetry;
@property (nonatomic,strong)MidtransInstallmentView *installmentsContentView;
@property (nonatomic) MidtransUICardFormatter *ccFormatter;
@property (nonatomic,strong) NSString *installmentBankName;
@property (nonatomic,strong) NSMutableArray *maskedCards;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConstraints;
@property (nonatomic,strong)NSMutableArray *installmentValueObject;
@property (nonatomic) NSArray *bins;
@property (nonatomic) NSArray *blackListBins;
@property (nonatomic,strong) MidtransBinResponse *filteredBinObject;
@property (nonatomic) BOOL installmentAvailable,installmentRequired,promoAvailable;
@property (nonatomic,strong) NSString *installmentTerms;
@property (nonatomic)NSInteger installmentCurrentIndex;
@property (strong,nonatomic) NSMutableArray *addOnArray;
@property (strong,nonatomic) NSMutableArray *promoArray;
@property (nonatomic,strong) NSMutableArray *currentPromo;
@property (nonatomic) NSInteger constraintsHeight;
@property (nonatomic,strong)NSArray *bankBinList;
@property (nonatomic) MidtransMaskedCreditCard *maskedCreditCard;
@property (nonatomic) MidtransPaymentRequestV2Response * responsePayment;
@property (nonatomic) BOOL bniPointActive;
@property (nonatomic) BOOL mandiriPointActive;
@property (nonatomic) BOOL isSaveCard;
@property (nonatomic) BOOL showUserForm;
@property (nonatomic,strong)AddOnConstructor *constructBNIPoint;
@property (nonatomic,strong)AddOnConstructor *constructMandiriPoint;
@property (nonatomic,strong) NSString *currentPromoSelected;
@property (nonatomic,strong) NSString *prevPromoSelected;
@property (nonatomic,strong) NSNumber *currentPromoIndex;
@property (nonatomic,strong) NSNumber *prevPromoIndex;
@property (nonatomic,strong) AddOnConstructor *selectedPromos;
@end

@implementation MidtransNewCreditCardViewController
@dynamic view;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
            andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard
 andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response *)responsePayment {
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        self.creditCardInfo = creditCard;
        self.responsePayment = responsePayment;
        self.paymentMethodInfo = paymentMethod;
    }
    return self;
}

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
                paymentMethod:(MidtransPaymentListModel *)paymentMethod
                   maskedCard:(MidtransMaskedCreditCard *)maskedCard
                   creditCard:(MidtransPaymentRequestV2CreditCard *)creditCard
 andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response *)responsePayment {
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        self.maskedCreditCard = maskedCard;
        self.creditCardInfo = creditCard;
        self.responsePayment = responsePayment;
        self.token = token;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.prevPromoIndex = nil;
    self.currentPromoSelected = @"";
    self.currentPromoIndex = nil;
    [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.input.title"];
    self.title =  [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.input.title"];//(@"creditcard.input.title", nil);
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.responsePayment.merchant.enabledPrinciples];
    NSString *imagePath = [NSString stringWithFormat:@"%@-seal",[array componentsJoinedByString:@"-"]];
    
    [self.view.secureBadgeImage setImage:[[UIImage imageNamed:imagePath inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    if (self.saveCreditCardOnly) {
        self.isSaveCard = NO;
        self.headerViewHeightConstraints.constant = 0.0f;
    }
    if (self.currentMaskedCards) {
        self.maskedCards = [NSMutableArray arrayWithArray:self.currentMaskedCards];
    }
    else {
        self.maskedCards = [NSMutableArray new];
    }
    NSLog(@"self.maskedCards-->%@",self.maskedCards);
    self.bniPointActive = NO;
    self.mandiriPointActive = NO;
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
    self.promoArray = [NSMutableArray new];
    self.currentPromo = [NSMutableArray new];
    [self.view configureAmountTotal:self.token];
    
    self.view.addOnTableView.delegate = self;
    self.view.addOnTableView.dataSource = self;
    
    self.view.promoTableView.delegate = self;
    self.view.promoTableView.dataSource = self;
    
    [self.view.promoTableView registerNib:[UINib nibWithNibName:@"MidtransCreditCardAddOnComponentCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransCreditCardAddOnComponentCell"];
    
    [self.view.addOnTableView registerNib:[UINib nibWithNibName:@"MidtransCreditCardAddOnComponentCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransCreditCardAddOnComponentCell"];
    
    self.constructBNIPoint = [[AddOnConstructor alloc]
                              initWithDictionary:@{@"addOnName":SNP_CORE_BNI_POINT,
                                                   @"addOnDescriptions":@"",
                                                   @"addOnTitle":[VTClassHelper getTranslationFromAppBundleForString:@"creditcard.Redeem BNI Reward Point"]}];
    self.constructMandiriPoint = [[AddOnConstructor alloc]
                              initWithDictionary:@{@"addOnName":SNP_CORE_MANDIRI_POINT,
                                                   @"addOnDescriptions":@"",
                                                   @"addOnTitle":[VTClassHelper getTranslationFromAppBundleForString:@"creditcard.Redeem MANDIRI Point"]}];
    
    self.isSaveCard = [CC_CONFIG setDefaultCreditSaveCardEnabled];
    self.showUserForm = [CC_CONFIG showFormCredentialsUser];
    self.view.userDetailViewWrapper.alpha = 0.0;
    self.view.userDetailViewWrapperConstraints.constant = 0.0f;
    self.view.contactEmailTextField.text = self.responsePayment.customerDetails.email;
    self.view.contactPhoneNumberTextField.text = self.responsePayment.customerDetails.phone;
    if (self.showUserForm) {
        self.view.contactEmailTextField.text = self.responsePayment.customerDetails.email;
        self.view.contactPhoneNumberTextField.text = self.responsePayment.customerDetails.phone;
        self.view.userDetailViewWrapper.hidden = NO;
        self.view.userDetailViewWrapper.alpha = 1.0f;
        self.view.userDetailViewWrapperConstraints.constant = 150.0f;
    }
    if ([CC_CONFIG saveCardEnabled] && (self.maskedCreditCard == nil)) {
        AddOnConstructor *constructSaveCard = [[AddOnConstructor alloc]
                                               initWithDictionary:@{@"addOnName":SNP_CORE_CREDIT_CARD_SAVE,
                                                                    @"addOnDescriptions":@"",
                                                                    @"addOnTitle":[VTClassHelper getTranslationFromAppBundleForString:@"creditcard.Save card for later use"]}];
        if (![self.addOnArray containsObject:constructSaveCard]) {
            [self.addOnArray insertObject:constructSaveCard atIndex:0];
            [self updateAddOnContent];
            
        }
    }
    
    self.installment = [[MidtransPaymentRequestV2Installment alloc]
                        initWithDictionary: [[self.creditCardInfo dictionaryRepresentation] valueForKey:@"installment"]];
   
    self.promos = self.responsePayment.promos;
 
    if (self.promos.promos.count) {
        for (MidtransPromoPromos *promos in self.promos.promos) {
            AddOnConstructor *promoConstructor = [[AddOnConstructor alloc] initWithDictionary:@{
                                                                                                @"addOnName":SNP_PROMO,
                                                                                                @"addOnTitle":promos.name,
                                                                                                @"addOnDescriptions":[NSString stringWithFormat:@"%0.f",promos.calculatedDiscountAmount],
                                                                                                @"addOnAdditional":[NSString stringWithFormat:@"%0.f",promos.promosIdentifier]
                             }];
          [self.promoArray addObject:promoConstructor];
          [self.currentPromo addObject:promoConstructor];
        }
        
        [self updatePromoContent];
        self.promoAvailable = YES;
    }

    if (self.installment.terms) {
        self.installmentAvailable = YES;
        self.installmentRequired = self.installment.required;
        [self setupInstallmentView];
    }
    [[SNPUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:@{@"installment available": @(self.installmentAvailable), @"installment required": @(self.installmentRequired)}];
  
    self.bins = self.creditCardInfo.whitelistBins;
    self.blackListBins = self.creditCardInfo.blacklistBins;
    
    self.bankBinList = [NSJSONSerialization JSONObjectWithData:[[NSData alloc]
                                                                initWithContentsOfFile:[VTBundle pathForResource:@"bin" ofType:@"json"]]
                                                       options:kNilOptions error:nil];
    
    if (self.maskedCreditCard) {
        self.view.creditCardNumberTextField.text = self.maskedCreditCard.formattedNumber;
        self.view.cardExpireTextField.text = @"\u2022\u2022 / \u2022\u2022";
        self.view.creditCardNumberTextField.enabled = NO;
        self.view.cardExpireTextField.enabled = NO;
        
        [self matchBINNumberWithInstallment:self.maskedCreditCard.maskedNumber];
        [self updateCreditCardTextFieldInfoWithNumber:self.maskedCreditCard.maskedNumber];
        
        self.view.creditCardNumberTextField.textColor = [UIColor grayColor];
        self.view.cardExpireTextField.textColor = [UIColor grayColor];
        
        //add delete button
        self.view.deleteButton.hidden = NO;
        [self.view.deleteButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Delete Saved Card"]
                                forState:UIControlStateNormal];
        [self.view.deleteButton addTarget:self action:@selector(deleteCardPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        self.view.creditCardNumberTextField.enabled = YES;
        self.view.cardExpireTextField.enabled = YES;
        self.view.creditCardNumberTextField.textColor = [UIColor darkTextColor];
        self.view.cardExpireTextField.textColor = [UIColor darkTextColor];
        self.view.deleteButton.hidden = YES;
    }
    
    [self.view.creditCardNumberTextField addObserver:self forKeyPath:@"text" options:0 context:nil];
    [self.view.cardCVVNumberTextField addObserver:self forKeyPath:@"text" options:0 context:nil];
    [self.view.cardExpireTextField addObserver:self forKeyPath:@"text" options:0 context:nil];
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.view.totalAmountPrice.textColor = [[MidtransUIThemeManager shared] themeColor];
    
    NSPredicate *oneClickPredicateFilter = [NSPredicate predicateWithFormat:@"%K like %@", NSStringFromSelector(@selector(tokenType)), TokenTypeOneClick];
    BOOL oneClickAvailable = [[self.creditCardInfo.savedTokens filteredArrayUsingPredicate:oneClickPredicateFilter] count] > 0;
    NSPredicate* twoClickPredicateFilter = [NSPredicate predicateWithFormat:@"%K like %@", NSStringFromSelector(@selector(tokenType)), TokenTypeTwoClicks];
    BOOL twoClickAvailable = [[self.creditCardInfo.savedTokens filteredArrayUsingPredicate:twoClickPredicateFilter] count] > 0;
    [[NSUserDefaults standardUserDefaults] setObject:@(oneClickAvailable) forKey:MIDTRANS_TRACKING_ONE_CLICK_AVAILABLE];
    [[NSUserDefaults standardUserDefaults] setObject:@(twoClickAvailable) forKey:MIDTRANS_TRACKING_TWO_CLICK_AVAILABLE];
    [[SNPUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:@{@"1 click token available": @(oneClickAvailable), @"2 clicks token available": @(twoClickAvailable)}];
}
- (void)totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    if (!self.selectedPromos) {
        [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails];
    } else {
        [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails WithPromoSelected:self.selectedPromos];
    }
    
}
- (IBAction)scanCardTapped:(id)sender {
    
}

- (void)deleteCardPressed:(id)sender {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.title"]
                               message:[VTClassHelper getTranslationFromAppBundleForString:@"alert.message-delete-card"]
                              delegate:self
                     cancelButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.no"]
                     otherButtonTitles:[VTClassHelper getTranslationFromAppBundleForString:@"alert.yes"], nil];
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


- (double)calculateDiscountPromo:(MidtransPromo *)promo {
    double result = 0;
    if ([promo.discountType isEqualToString:@"PERCENTED"]) {
        result = self.token.transactionDetails.grossAmount.doubleValue * (promo.discountAmount/100.0);
    }
    else {
        result = promo.discountAmount;
    }
    return result;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.view.addOnTableView) {
        return self.addOnArray.count;
    } else {
         return self.promoArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.view.addOnTableView) {
        AddOnConstructor *payAddOn = [self.addOnArray objectAtIndex:indexPath.row];
        MidtransCreditCardAddOnComponentCell *cell = (MidtransCreditCardAddOnComponentCell *)[tableView dequeueReusableCellWithIdentifier:@"MidtransCreditCardAddOnComponentCell"];
        
        cell.checkButton.tag = indexPath.row;
        cell.addOnInformationButton.tag = indexPath.row;
        [cell configurePaymentAddOnWithData:payAddOn];
        
        [cell.checkButton addTarget:self action:@selector(checkButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addOnInformationButton addTarget:self action:@selector(informationButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        if ([payAddOn.addOnName isEqualToString:SNP_CORE_CREDIT_CARD_SAVE]) {
            cell.checkButton.selected = self.isSaveCard;
            return cell;
        }
        else if ([payAddOn.addOnName isEqualToString:SNP_CORE_BNI_POINT]) {
            cell.checkButton.selected = self.bniPointActive;
        }
        else if(indexPath.row == [self.currentPromoIndex integerValue]){
            cell.checkButton.selected = !cell.checkButton.selected;
        }
        else if ([payAddOn.addOnName isEqualToString:SNP_CORE_MANDIRI_POINT]) {
            cell.checkButton.selected = self.mandiriPointActive;
        }
        
        
        return cell;
    }  else {
        AddOnConstructor *payAddOn = [self.promoArray objectAtIndex:indexPath.row];
        AddOnConstructor *payAddOnCurrent;
        if (self.currentPromoIndex!=nil) {
            payAddOnCurrent = [self.promoArray objectAtIndex:[self.currentPromoIndex integerValue]];
        }
        MidtransCreditCardAddOnComponentCell *cell = (MidtransCreditCardAddOnComponentCell *)[tableView dequeueReusableCellWithIdentifier:@"MidtransCreditCardAddOnComponentCell"];
        cell.checkButton.tag = indexPath.row;
        cell.addOnInformationButton.tag = indexPath.row;
        [cell configurePromoWithData:payAddOn];
        [cell.checkButton addTarget:self action:@selector(checkButtonTapPromo:) forControlEvents:UIControlEventTouchUpInside];
        if ([payAddOnCurrent.addOnTitle isEqualToString:payAddOn.addOnTitle]) {
            cell.checkButton.selected = YES;
        } else {
             cell.checkButton.selected = NO;
        }
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell updateConstraintsIfNeeded];
        [cell layoutIfNeeded];
        float height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height;
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

- (void)updateAddOnContent {
    self.view.addOnTableViewHeightConstraints.constant = self.addOnArray.count * 50;
    [self.view.addOnTableView reloadData];
}
- (void)updatePromoContent {
    self.view.promoTableViewHeightConstraints.constant = self.promoArray.count * 50;
    [self.view.promoTableView reloadData];
}
- (void)updatePromoViewWithCreditCardNumber:(NSString *)number {
    [self.promos dictionaryRepresentation];
    if (number.length == 0) {
        [self.promoArray removeAllObjects];
        [self.promoArray addObjectsFromArray:self.currentPromo];
    } else {
        self.currentPromoSelected = @"";
        self.currentPromoIndex = nil;
        self.prevPromoIndex = nil;
       NSArray *filtered = [self.promos.promos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"bins CONTAINS [cd] %@", [NSString stringWithFormat:@"%@", number]]];
        
        if (filtered.count) {
             [self.promoArray removeAllObjects];
             [self updatePromoContent];
        } else {
             [self updatePromoContent];
        }
        for (MidtransPromoPromos *promos in filtered) {
            AddOnConstructor *promoConstructor = [[AddOnConstructor alloc] initWithDictionary:@{
                                                                                                @"addOnName":SNP_PROMO,
                                                                                                @"addOnTitle":promos.name,
                                                                                                @"addOnDescriptions":[NSString stringWithFormat:@"%0.f",promos.calculatedDiscountAmount],
                                                                                                @"addOnAdditional":[NSString stringWithFormat:@"%0.f",promos.promosIdentifier]
                                                                                                }];
            [self.promoArray addObject:promoConstructor];
        }
    }
    [self updatePromoContent];

}

- (void)updateCreditCardTextFieldInfoWithNumber:(NSString *)number {
    if ([self.responsePayment.merchant.enabledPrinciples containsObject:[[MidtransCreditCardHelper nameFromString:number] lowercaseString]]) {
        self.view.creditCardNumberTextField.info1Icon = [self.view iconDarkWithNumber:number];
    }
    else {
        self.view.creditCardNumberTextField.info1Icon = nil;
    }
    UIImage *bankIcon = [self.view iconWithBankName:self.filteredBinObject.bank];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.creditCardNumberTextField.info2Icon = bankIcon;
    });
}

#pragma mark - VTCardFormatterDelegate

- (void)formatter_didTextFieldChange:(MidtransUICardFormatter *)formatter {
    NSString *originNumber = [self.view.creditCardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.promoAvailable) {
       [self updatePromoViewWithCreditCardNumber:originNumber];
    }
     [self matchBINNumberWithInstallment:originNumber];
    
    [self updateCreditCardTextFieldInfoWithNumber:originNumber];
    
    [[MidtransClient shared] requestCardBINForInstallmentWithCompletion:^(NSArray * _Nullable binResponse, NSError * _Nullable error) {
        self.bankBinList = binResponse;
        [self matchBINNumberWithInstallment:originNumber];
        [self updateCreditCardTextFieldInfoWithNumber:originNumber];
    }];
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
                                                      initWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"what is cvv?"]
                                                      message:[VTClassHelper getTranslationFromAppBundleForString:@"The CVV is a 3 (or 6) digit number security code printed on the back of your card"]
                                                      image:@"CreditCardBackSmall"
                                                      delegate:nil
                                                      cancelButtonTitle:nil
                                                      okButtonTitle:@"Ok"];
    
    [self.navigationController presentCustomViewController:alertView
                                          onViewController:self.navigationController
                                                completion:nil];
}
- (void)checkButtonTapPromo:(UIButton *)sender {
    [self updatePromoContent];
    AddOnConstructor *constructor = [self.promoArray objectAtIndex:sender.tag];
    
    self.currentPromoIndex = [NSNumber numberWithUnsignedInteger:sender.tag];
    if (self.prevPromoIndex != nil){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.prevPromoIndex integerValue] inSection:0];
        MidtransCreditCardAddOnComponentCell* cell = [self.view.promoTableView cellForRowAtIndexPath:indexPath];
        cell.checkButton.selected = NO;
        [self.view.promoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
         [self updateAmountTotal:[AddOnConstructor new]];
    } if (self.prevPromoIndex == self.currentPromoIndex){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.prevPromoIndex integerValue] inSection:0];
        MidtransCreditCardAddOnComponentCell* cell = [self.view.promoTableView cellForRowAtIndexPath:indexPath];
        cell.checkButton.selected = NO;
        self.currentPromoIndex = nil;
        [self.view.promoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        constructor = [AddOnConstructor new];
    }
    
    self.currentPromoSelected = constructor.addOnTitle;
    self.prevPromoIndex = self.currentPromoIndex;
     [self updateAmountTotal:constructor];
   
}
- (void)checkButtonTap:(UIButton *)sender {
    [self updateAddOnContent];
    AddOnConstructor *constructor = [self.addOnArray objectAtIndex:sender.tag];
   
    if ([constructor.addOnName isEqualToString:SNP_CORE_CREDIT_CARD_SAVE]) {
        self.isSaveCard = !sender.selected;
        [self.view.addOnTableView reloadData];
    }
    else if ([constructor.addOnName isEqualToString:SNP_CORE_MANDIRI_POINT]) {
        self.mandiriPointActive = !sender.selected;
        [self.view.addOnTableView reloadData];
    }
    else if ([constructor.addOnName isEqualToString:SNP_CORE_BNI_POINT]) {
        [self openCommonTSCWithBank:SNP_CORE_BNI_POINT];
        [self.view.addOnTableView reloadData];
    }
    
}
- (void)updateAmountTotal:(AddOnConstructor *)constructor{
    if (constructor){
        NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [constructor.addOnDescriptions integerValue];
        NSNumber *castingNumber  = [NSNumber numberWithInteger:totalOrder];
        self.selectedPromos = constructor;
        self.view.totalAmountPrice.text =castingNumber.formattedCurrencyNumber;
    } else {
        self.view.totalAmountPrice.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    }
}
- (void)openCommonTSCWithBank:(NSString *)bank{
    MidtransCommonTSCViewController *tscViewController = [[MidtransCommonTSCViewController alloc] initWithNibName:@"MidtransCommonTSCViewController" bundle:VTBundle];
    tscViewController.delegate = self;
    tscViewController.bankID = bank;
    [self.navigationController pushViewController:tscViewController animated:YES];
}

- (void)agreeTermAndConditionDidtapped:(NSString *)bankName {
    if ([bankName isEqualToString:SNP_CORE_BNI_POINT]) {
        self.bniPointActive = true;
         [self.view.addOnTableView reloadData];
    }
}
- (void)informationButtonTap:(UIButton *)sender {
    AddOnConstructor *constructor = [self.addOnArray objectAtIndex:sender.tag];
    if ([constructor.addOnName isEqualToString:SNP_CORE_CREDIT_CARD_SAVE]) {
        
        MidtransUICustomAlertViewController *alertView = [[MidtransUICustomAlertViewController alloc]
                                                          initWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"creditcard.save card for later reuse"]
                                                          message:[VTClassHelper getTranslationFromAppBundleForString:@"creditcard.we will securely store your card details so you can reuse them later"]
                                                          image:nil
                                                          delegate:nil
                                                          cancelButtonTitle:nil
                                                          okButtonTitle:@"ok"];
        
        [self.navigationController presentCustomViewController:alertView
                                              onViewController:self.navigationController
                                                    completion:nil];
    }
    else if ([constructor.addOnName isEqualToString:SNP_CORE_BNI_POINT]) {
        MidtransUICustomAlertViewController *alertView = [[MidtransUICustomAlertViewController alloc]
                                                          initWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"redeem bni reward point"]
                                                          message:[VTClassHelper getTranslationFromAppBundleForString:@"you can pay partly through the redemption of BNI Reward Point through your credit card"]
                                                          image:nil
                                                          delegate:nil
                                                          cancelButtonTitle:nil
                                                          okButtonTitle:@"ok"];
        
        [self.navigationController presentCustomViewController:alertView
                                              onViewController:self.navigationController
                                                    completion:nil];
    }
    else if ([constructor.addOnName isEqualToString:SNP_CORE_MANDIRI_POINT]) {
        MidtransUICustomAlertViewController *alertView = [[MidtransUICustomAlertViewController alloc]
                                                          initWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"redeem mandiri reward point"]
                                                          message:[VTClassHelper getTranslationFromAppBundleForString:@"you can pay partly through the redemption of BNI Reward Point through your credit card"]
                                                          image:nil
                                                          delegate:nil
                                                          cancelButtonTitle:nil
                                                          okButtonTitle:@"ok"];
        
        [self.navigationController presentCustomViewController:alertView
                                              onViewController:self.navigationController
                                                    completion:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSError *error;
    if ([textField isEqual:self.view.creditCardNumberTextField]) {
        [textField.text isValidCreditCardNumber:&error];
    }
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
        MidtransUICustomAlertViewController *alertView = [[MidtransUICustomAlertViewController alloc]
                                                          initWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"creditcard.promo-title"]
                                                          message:@""
                                                          image:nil
                                                          delegate:nil
                                                          cancelButtonTitle:nil
                                                          okButtonTitle:@"OK"];
        
        [self.navigationController presentCustomViewController:alertView
                                              onViewController:self.navigationController
                                                    completion:nil];
    }
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
            self.filteredBinObject = [[MidtransBinResponse alloc] initWithDictionary:[filtered firstObject]];
            if (filtered.count > 1) {
                NSArray *debitCard  = [filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF['bank'] CONTAINS 'debit'"]];
                if (debitCard.count) {
                    MidtransBinResponse *debitCardObject = [[MidtransBinResponse alloc] initWithDictionary:[debitCard firstObject]];
                    if ([debitCardObject.bank containsString:SNP_CORE_BANK_MANDIRI]) {
                        isDebitCard = YES;
                        self.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.Mandiri Debit Card"];
                        self.filteredBinObject.bank = SNP_CORE_BANK_MANDIRI;
                        if ([self.responsePayment.merchant.pointBanks containsObject:SNP_CORE_BANK_MANDIRI]) {
                            if (![self.addOnArray containsObject:self.constructMandiriPoint]) {
                                [self.addOnArray addObject:self.constructMandiriPoint];
                                [self updateAddOnContent];
                            }
                        }
                    } else if ([debitCardObject.bank containsString:SNP_CORE_BANK_BNI]) {
                        isDebitCard = YES;
                        self.title = [VTClassHelper getTranslationFromAppBundleForString:@"BNI Card"];
                        self.filteredBinObject.bank = SNP_CORE_BANK_BNI;
                    }
                }
                
            }
            else {
                
                if ([self.filteredBinObject.bank containsString:SNP_CORE_DEBIT_CARD]) {
                    if ([self.filteredBinObject.bank containsString:SNP_CORE_BANK_MANDIRI]) {
                        self.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.Mandiri Debit Card"];
                        self.filteredBinObject.bank = SNP_CORE_BANK_MANDIRI;
                        
                    }
                    else if ([self.filteredBinObject.bank containsString:SNP_CORE_BANK_BNI]) {
                        self.title = [VTClassHelper getTranslationFromAppBundleForString:@"BNI Card"];
                        self.filteredBinObject.bank = SNP_CORE_BANK_BNI;
                    }
                    isDebitCard = YES;
                }
                else {
                    if ([self.filteredBinObject.bank isEqualToString:SNP_CORE_BANK_MANDIRI]) {
                        if ([self.responsePayment.merchant.pointBanks containsObject:SNP_CORE_BANK_MANDIRI]) {
                            if (![self.addOnArray containsObject:self.constructMandiriPoint]) {
                                [self.addOnArray addObject:self.constructMandiriPoint];
                                [self updateAddOnContent];
                            }
                        }
                    }
                    if ([self.filteredBinObject.bank isEqualToString:SNP_CORE_BANK_BNI]) {
                        if ([self.responsePayment.merchant.pointBanks containsObject:SNP_CORE_BANK_BNI] ) {
                            if (![self.addOnArray containsObject:self.constructBNIPoint]) {
                                [self.addOnArray addObject:self.constructBNIPoint];
                                [self updateAddOnContent];
                            }
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
            self.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.input.title"];
            if ([[self.installment.terms objectForKey:@"offline"] count]) {
                if (!isDebitCard) {
                    self.installmentBankName = @"offline";
                    [self.installmentValueObject setArray:@[@"0"]];
                    [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:self.installmentBankName]];
                    [self showInstallmentView:YES];
                }
            }
        }
    }
    else {
        if ([self.addOnArray containsObject:self.constructBNIPoint]) {
            [self.addOnArray removeObject:self.constructBNIPoint];
            [self updateAddOnContent];
        }
        if ([self.addOnArray containsObject:self.constructMandiriPoint]) {
            [self.addOnArray removeObject:self.constructMandiriPoint];
            [self updateAddOnContent];
        }
        
        
        self.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.input.title"];
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.view.installmentView.hidden = !show;
                            [self.installmentsContentView.installmentCollectionView reloadData];
                        });
                        [self.installmentsContentView configureInstallmentView:self.installmentValueObject];
                    }
                    completion:NULL];
}

- (IBAction)submitPaymentDidtapped:(id)sender {
    
    if (self.saveCreditCardOnly) {
        NSArray *data = [self.view.cardExpireTextField.text componentsSeparatedByString:@"/"];
        NSString *expMonth = [data[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *expYear = [NSString stringWithFormat:@"%ld",[data[1] integerValue]+2000];
        

        MidtransCreditCard *creditCard = [[MidtransCreditCard alloc] initWithNumber: [self.view.creditCardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]
                                                                        expiryMonth:expMonth
                                                                         expiryYear:expYear
                                                                                cvv:self.view.cardCVVNumberTextField.text];
        [[MidtransClient shared] registerCreditCard:creditCard completion:^(MidtransMaskedCreditCard * _Nullable maskedCreditCard, NSError * _Nullable error) {
            [self hideLoading];
            
            if (!error) {
                [self handleSaveCardSuccess:maskedCreditCard];
            }
            else {
                [self handleRegisterCreditCardError:error];
            }
        }];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(self.installmentAvailable) forKey:MIDTRANS_TRACKING_INSTALLMENT_AVAILABLE];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.installmentRequired) forKey:MIDTRANS_TRACKING_INSTALLMENT_REQUIRED];
    NSMutableDictionary *additionalData = [NSMutableDictionary dictionaryWithDictionary:@{@"installment available": @(self.installmentAvailable), @"installment required": @(self.installmentRequired)}];
    if (self.responsePayment.transactionDetails.orderId) {
        [additionalData addEntriesFromDictionary:@{@"order id": self.responsePayment.transactionDetails.orderId}];
    }
    [[SNPUITrackingManager shared] trackEventName:@"btn confirm payment" additionalParameters:additionalData];
    if (self.installmentAvailable && self.installmentCurrentIndex !=0 && !self.bniPointActive && !self.mandiriPointActive) {
        self.installmentTerms = [NSString stringWithFormat:@"%@_%@",self.installmentBankName,
                                 [[self.installment.terms  objectForKey:self.installmentBankName] objectAtIndex:self.installmentCurrentIndex -1]];
    }
    
    if (self.installmentRequired && self.installmentCurrentIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:[VTClassHelper getTranslationFromAppBundleForString:@"This transaction must use installment"]
                                                       delegate:nil
                                              cancelButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
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
    
    if (self.blackListBins.count) {
        NSError *error;
        if ([MidtransClient isCreditCardNumber:cardNumber containBlacklistBins:self.blackListBins error:&error]) {
            [self.view isViewableError:error];
            return;
        }
    }
    
    if (self.bins.count) {
        NSError *error;
        if (![MidtransClient isCreditCardNumber:cardNumber eligibleForBins:self.bins error:&error]) {
            [self.view isViewableError:error];
            return;
        }
    }
    
    MidtransTokenizeRequest *tokenRequest;
    
    if (self.maskedCreditCard) {
        if (!self.view.cardCVVNumberTextField.text.length) {
            self.view.cardCVVNumberTextField.warning = [VTClassHelper getTranslationFromAppBundleForString:@"CVV is invalid"];
            return;
        }
        
        if (self.selectedPromos){
            NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [self.selectedPromos.addOnDescriptions integerValue];
            NSNumber *castingNumber  = [NSNumber numberWithInteger:totalOrder];
            tokenRequest = [[MidtransTokenizeRequest alloc] initWithTwoClickToken:self.maskedCreditCard.savedTokenId
                                                                              cvv:self.view.cardCVVNumberTextField.text
                                                                      grossAmount:castingNumber];
        } else {
            tokenRequest = [[MidtransTokenizeRequest alloc] initWithTwoClickToken:self.maskedCreditCard.savedTokenId
                                                                              cvv:self.view.cardCVVNumberTextField.text
                                                                      grossAmount:self.token.transactionDetails.grossAmount];
        }
        
    
    }
    else {
        
        if (self.selectedPromos){
            NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [self.selectedPromos.addOnDescriptions integerValue];
            NSNumber *castingNumber  = [NSNumber numberWithInteger:totalOrder];
            tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                   grossAmount:castingNumber
                                                                        secure:CC_CONFIG.secure3DEnabled];
        } else {
            tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                   grossAmount:self.token.transactionDetails.grossAmount
                                                                        secure:CC_CONFIG.secure3DEnabled];
        }
        
    }
    
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    
    if (self.installmentTerms && self.installmentCurrentIndex !=0) {
        NSInteger installment = [self.installment.terms[self.installmentBankName][self.installmentCurrentIndex-1] integerValue];
        tokenRequest.installment = YES;
        tokenRequest.installmentTerm = @(installment);
    }
    if (self.bniPointActive || self.mandiriPointActive) {
        tokenRequest.point = YES;
        [[MidtransClient shared] generateTokenWithSkipping3DS:tokenRequest
                                                   completion:^(NSDictionary * _Nullable token, NSError * _Nullable error) {
            [self hideLoading];
            if (error) {
                
                [self handleTransactionError:error];
            } else {
                SNPPointViewController *pointVC = [[SNPPointViewController alloc] initWithToken:self.token
                                                                                  paymentMethod:self.paymentMethod
                                                                                  tokenizedCard: token[@"token_id"]
                                                                                      savedCard:self.isSaveCard
                                                                   andCompleteResponseOfPayment:self.responsePayment];
                
                if (self.bniPointActive) {
                    pointVC.bankName = SNP_CORE_BANK_BNI;
                }
                else if (self.mandiriPointActive) {
                    pointVC.bankName = SNP_CORE_BANK_MANDIRI;
                }
                pointVC.redirectURL = token[@"redirect_url"];
                pointVC.currentMaskedCards = self.currentMaskedCards;
                [self.navigationController pushViewController:pointVC animated:YES];
                [self hideLoading];
            }
        }];
        

        return;
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
    self.token.customerDetails.phone = self.view.contactPhoneNumberTextField.text;
    self.token.customerDetails.email = self.view.contactEmailTextField.text;
    
    
    MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard modelWithToken:token
                                                                                customer:self.token.customerDetails
                                                                                saveCard:self.isSaveCard
                                                                             installment:self.installmentTerms];
    

    MidtransTransaction *transaction = [[MidtransTransaction alloc]
                                        initWithPaymentDetails:paymentDetail token:self.token];
    
    if (self.selectedPromos){
        if (self.selectedPromos.addOnAddtional) {
            NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [self.selectedPromos.addOnDescriptions integerValue];
            NSNumber *castingNumber  = [NSNumber numberWithInteger:totalOrder];
            
            NSDictionary *promoConstructor = @{@"discounted_gross_amount":castingNumber,
                                               @"promo_id":self.selectedPromos.addOnAddtional
                                               };
            
            paymentDetail = [MidtransPaymentCreditCard modelWithToken:token
                                                             customer:self.token.customerDetails
                                                             saveCard:self.isSaveCard
                                                          installment:self.installmentTerms
                                                               promos:promoConstructor];
            transaction = [[MidtransTransaction alloc]
                           initWithPaymentDetails:paymentDetail token:self.token];
        }
    }
    
    if (self.bniPointActive || self.mandiriPointActive) {
        [self hideLoading];

        SNPPointViewController *pointVC = [[SNPPointViewController alloc] initWithToken:self.token
                                                                          paymentMethod:self.paymentMethod
                                                                          tokenizedCard:token
                                                                              savedCard:self.isSaveCard
                                                           andCompleteResponseOfPayment:self.responsePayment];
        if (self.bniPointActive) {
            pointVC.bankName = SNP_CORE_BANK_BNI;
        }
        else if (self.mandiriPointActive) {
            pointVC.bankName = SNP_CORE_BANK_MANDIRI;
        }
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
                                                       cancelButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
                                                       otherButtonTitles:nil];
                 [alert show];
             }
             else {
                 [self handleTransactionError:error];
             }
         }
         else {
             if ([CC_CONFIG tokenStorageEnabled] && result.maskedCreditCard) {
                 NSUInteger index = [self.maskedCards indexOfObjectPassingTest:^BOOL(MidtransMaskedCreditCard *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     NSString *masked = [result.additionalData objectForKey:@"masked_card"];
                     return [masked isEqualToString:obj.maskedNumber];
                 }];
                 if (index == NSNotFound) {
                     MidtransMaskedCreditCard *constructMaskedCard = [[MidtransMaskedCreditCard alloc] initWithSavedTokenId:[result.additionalData valueForKey:@"saved_token_id"] maskedNumber:[result.additionalData valueForKey:@"masked_card"] tokenType:@"" expiresAt:@""];
                     [self.maskedCards addObject:constructMaskedCard];
                 }
                 
                 [[MidtransMerchantClient shared] saveMaskedCards:self.maskedCards
                                                         customer:self.token.customerDetails
                                                       completion:^(id  _Nullable result, NSError * _Nullable error) {

                                                       }];
             }
             if ([[result.additionalData objectForKey:@"fraud_status"] isEqualToString:@"challenge"]) {
                 if (result.statusCode == 201) {
                     [self handleRBATransactionWithTransactionResult:result withTransactionData:transaction];
                 }
                 else {
                   [self handleTransactionSuccess:result];
                 }
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
                     if (result.statusCode == 201) {
                         [self handleRBATransactionWithTransactionResult:result withTransactionData:transaction];
                     }
                     else {
                       [self handleTransactionSuccess:result];
                     }
                     
                 }
             }
         }
     }];
}
-(void)handleRBATransactionWithTransactionResult:(MidtransTransactionResult *)result
                             withTransactionData:(MidtransTransaction *)transaction  {
    
    Midtrans3DSController *secureController = [[Midtrans3DSController alloc] initWithToken:nil
                                                                                 secureURL:[NSURL URLWithString:[result.additionalData objectForKey:@"redirect_url"]]];
    secureController.transcationData = transaction;
    secureController.delegate = self;
    [secureController showWithCompletion:^(NSError *error) {
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
    
}
- (void)rbaDidGetError:(NSError *)error{
    [self handleTransactionError:error];
}

- (void)rbaDidGetTransactionStatus:(MidtransTransactionResult *)transactionResult {
    [self handleTransactionSuccess:transactionResult];
}
- (void)handleRegisterCreditCardError:(NSError *)error {
    if ([self.view isViewableError:error] == NO) {
        [self showAlertViewWithTitle:@"Error"
                          andMessage:error.localizedDescription
                      andButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]];
    }
}

-(void)installmentSelectedIndex:(NSInteger)index {
    self.installmentCurrentIndex = index;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self showLoadingWithText:nil];
        if ([CC_CONFIG tokenStorageEnabled]) {
            NSUInteger index = [self.maskedCards indexOfObjectPassingTest:^BOOL(MidtransMaskedCreditCard *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [self.maskedCreditCard.maskedNumber isEqualToString:obj.maskedNumber];
            }];
            if (index != NSNotFound) {
                [self.maskedCards removeObjectAtIndex:index];
            }
            
            [[MidtransMerchantClient shared] saveMaskedCards:self.maskedCards
                                                    customer:self.token.customerDetails
                                                  completion:^(id  _Nullable result, NSError * _Nullable error) {
                                                      [self hideLoading];
                                                      if ([self.delegate respondsToSelector:@selector(didDeleteSavedCard)]) {
                                                          [self.delegate didDeleteSavedCard];
                                                      }
                                                  }];
        } else {
        [[MidtransMerchantClient shared] deleteMaskedCreditCard:self.maskedCreditCard token:self.token completion:^(BOOL success) {
            [self hideLoading];
            
            if (success == NO) {
                return;
            }
            
            NSMutableArray *savedTokensM = self.creditCardInfo.savedTokens.mutableCopy;
            NSUInteger index = [savedTokensM indexOfObjectPassingTest:^BOOL(MidtransPaymentRequestV2SavedTokens *savedToken, NSUInteger idx, BOOL * _Nonnull stop) {
                return [self.maskedCreditCard.maskedNumber isEqualToString:savedToken.maskedCard];
            }];
            if (index != NSNotFound) {
                [savedTokensM removeObjectAtIndex:index];
            }
            self.creditCardInfo.savedTokens = savedTokensM;
            
            if ([self.delegate respondsToSelector:@selector(didDeleteSavedCard)]) {
                [self.delegate didDeleteSavedCard];
            }
        }];
        }}
}

#pragma mark - observer
/**
 we will refactor this on next chore
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSString *ccnumber = [self.view.creditCardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *bank = self.filteredBinObject.bank;
    
    if ([keyPath isEqualToString:@"text"] && object == self.view.creditCardNumberTextField) {
        if (([bank isEqualToString:@"bni"] || [bank isEqualToString:@"mandiri"]) &&
            ccnumber.length == 16) {
               return;
        }
        else {
            switch ([MidtransCreditCardHelper typeFromString:ccnumber]) {
                    case VTCreditCardTypeAmex:
                    if (ccnumber.length == 15) {
                        return;
                       // [self.view.cardExpireTextField becomeFirstResponder];
                    }
                    break;
                    case VTCreditCardTypeJCB:
                    case VTCreditCardTypeVisa:
                    case VTCreditCardTypeMasterCard:
                    if (ccnumber.length == 16) {
                          return;
                    }
                    break;
                default:
                    
                    break;
            }
        }
    }
    else if ([keyPath isEqualToString:@"text"] && object == self.view.cardExpireTextField) {
        NSString *unformatText = [self.view.cardExpireTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (unformatText.length == 5) {
           // [self.view.cardCVVNumberTextField becomeFirstResponder];
        }
    }
    else if ([keyPath isEqualToString:@"text"] && object == self.view.cardCVVNumberTextField) {
        NSInteger maxLength = 0;
        if ([bank isEqualToString:@"bni"]) {
            maxLength = 6;
        }
        else if ([MidtransCreditCardHelper typeFromString:ccnumber] == VTCreditCardTypeAmex) {
            maxLength = 4;
        }
        else {
            maxLength = 3;
        }
        
        if (self.view.cardCVVNumberTextField.text.length == maxLength) {
            [self.view endEditing:YES];
        }
    }
}

@end
