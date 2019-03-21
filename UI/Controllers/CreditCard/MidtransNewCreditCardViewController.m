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
#import "MidtransCreditCardAddOnComponentCell.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransTransactionDetailViewController.h"
#import "MidtransUIThemeManager.h"
#import "MIDBinResponse.h"
#import "MIDConstants.h"
#import "MID3DSController.h"
#import "MIDUIModelHelper.h"
#import "MIDCreditCardModel.h"
#import "MIDCreditCardHelper.h"
#import "MIDUITrackingManager.h"
#import "MIDVendorUI.h"
#import "MIDUIModelHelper.h"

@interface MidtransNewCreditCardViewController () <
UITableViewDelegate,
UITableViewDataSource,
MidtransUITextFieldDelegate,
MidtransUICardFormatterDelegate,
MidtransInstallmentViewDelegate,
MID3DSControllerDelegate,
MidtransCommonTSCViewControllerDelegate
>

@property (nonatomic,strong) MIDInstallmentInfo *installmentInfo;
@property (nonatomic,strong)NSMutableArray *installmentValueObject;
@property (nonatomic) NSArray *bins;
@property (nonatomic) NSArray *blackListBins;
@property (nonatomic,strong) MIDBinResponse *filteredBinObject;
@property (nonatomic,strong)NSArray *bankBinList;

@property (strong, nonatomic) IBOutlet MidtransNewCreditCardView *view;
@property (weak, nonatomic) IBOutlet MidtransUINextStepButton *bottomButton;
@property (nonatomic) NSInteger attemptRetry;
@property (nonatomic,strong)MidtransInstallmentView *installmentsContentView;
@property (nonatomic) MidtransUICardFormatter *ccFormatter;
@property (nonatomic,strong) NSString *installmentBankName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConstraints;
@property (nonatomic) BOOL installmentAvailable,installmentRequired,promoAvailable;
@property (nonatomic,strong) NSString *installmentTerms;
@property (nonatomic)NSInteger installmentCurrentIndex;
@property (strong,nonatomic) NSMutableArray *addOnArray;
@property (strong,nonatomic) NSMutableArray *promoArray;
@property (nonatomic,strong) NSMutableArray *currentPromo;
@property (nonatomic) NSInteger constraintsHeight;
@property (nonatomic) BOOL bniPointActive;
@property (nonatomic) BOOL mandiriPointActive;
@property (nonatomic) BOOL showUserForm;
@property (nonatomic,strong)AddOnConstructor *constructBNIPoint;
@property (nonatomic,strong)AddOnConstructor *constructMandiriPoint;
@property (nonatomic,strong) NSString *currentPromoSelected;
@property (nonatomic,strong) NSString *prevPromoSelected;
@property (nonatomic,strong) NSNumber *currentPromoIndex;
@property (nonatomic,strong) NSNumber *prevPromoIndex;
@property (nonatomic,strong) AddOnConstructor *selectedPromos;

@property (nonatomic) BOOL isSaveCard;
@end

@implementation MidtransNewCreditCardViewController {
    NSString *_cardTokenID;
}

@dynamic view;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.prevPromoIndex = nil;
    self.currentPromoSelected = @"";
    self.currentPromoIndex = nil;
    [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.input.title"];
    self.title =  [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.input.title"];//(@"creditcard.input.title", nil);
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.info.merchant.enabledPrinciples];
    NSString *imagePath = [NSString stringWithFormat:@"%@-seal",[array componentsJoinedByString:@"-"]];
    
    [self.view.secureBadgeImage setImage:[[UIImage imageNamed:imagePath inBundle:VTBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

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
    [self.view configureAmountTotal:self.info];
    
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
    
    self.showUserForm = YES;
    self.view.userDetailViewWrapper.hidden = YES;
    self.view.userDetailViewWrapperConstraints.constant = 0.0f;
    self.view.contactEmailTextField.text = self.info.customer.email;
    self.view.contactPhoneNumberTextField.text = self.info.customer.phone;
    if (self.showUserForm) {
        self.view.contactEmailTextField.text = self.info.customer.email;
        self.view.contactPhoneNumberTextField.text = self.info.customer.phone;
        self.view.userDetailViewWrapper.hidden = NO;
        self.view.userDetailViewWrapperConstraints.constant = 150.0f;
    }
    if (self.savedCardInfo == nil) {
        AddOnConstructor *constructSaveCard = [[AddOnConstructor alloc]
                                               initWithDictionary:@{@"addOnName":SNP_CORE_CREDIT_CARD_SAVE,
                                                                    @"addOnDescriptions":@"",
                                                                    @"addOnTitle":[VTClassHelper getTranslationFromAppBundleForString:@"creditcard.Save card for later use"]}];
        if (![self.addOnArray containsObject:constructSaveCard]) {
            [self.addOnArray insertObject:constructSaveCard atIndex:0];
            [self updateAddOnContent];
            
        }
    }
    
    self.installmentInfo = self.info.creditCard.installment;
    
    if (self.promoInfo.promos.count) {
        for (MIDPromo *promo in self.promoInfo.promos) {
            AddOnConstructor *promoConstructor = [[AddOnConstructor alloc] initWithDictionary:@{
                                                                                                @"addOnName":@"SNP_PROMO",
                                                                                                @"addOnTitle":promo.name,
                                                                                                @"addOnDescriptions":[NSString stringWithFormat:@"%@",promo.calculatedDiscountAmount],
                                                                                                @"addOnAdditional":[NSString stringWithFormat:@"%@",promo.promoID]
                                                                                                }];
            [self.promoArray addObject:promoConstructor];
            [self.currentPromo addObject:promoConstructor];
        }
        
        [self updatePromoContent];
        self.promoAvailable = YES;
    }
    
    if (self.installmentInfo.terms) {
        self.installmentAvailable = YES;
        self.installmentRequired = self.installmentInfo.required;
        [self setupInstallmentView];
    }
    [[MIDUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:@{@"installment available": @(self.installmentAvailable), @"installment required": @(self.installmentRequired)}];
    
    self.bins = self.info.creditCard.whitelistBins;
    self.blackListBins = self.info.creditCard.blacklistBins;
    
    self.bankBinList = [NSJSONSerialization JSONObjectWithData:[[NSData alloc]
                                                                initWithContentsOfFile:[VTBundle pathForResource:@"bin" ofType:@"json"]]
                                                       options:kNilOptions error:nil];
    
    if (self.savedCardInfo) {
        self.view.creditCardNumberTextField.text = self.savedCardInfo.formattedNumber;
        self.view.cardExpireTextField.text = @"\u2022\u2022 / \u2022\u2022";
        self.view.creditCardNumberTextField.enabled = NO;
        self.view.cardExpireTextField.enabled = NO;
        
        [self matchBINNumberWithInstallment:self.savedCardInfo.maskedCard];
        [self updateCreditCardTextFieldInfoWithNumber:self.savedCardInfo.maskedCard];
        
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
    
    NSPredicate *oneClickPredicateFilter = [NSPredicate predicateWithFormat:@"%K == %i", NSStringFromSelector(@selector(tokenType)), MIDCardTokenTypeTwoClick];
    BOOL oneClickAvailable = [[self.info.creditCard.savedCards filteredArrayUsingPredicate:oneClickPredicateFilter] count] > 0;
    NSPredicate *twoClickPredicateFilter = [NSPredicate predicateWithFormat:@"%K == %i", NSStringFromSelector(@selector(tokenType)), MIDCardTokenTypeTwoClick];
    BOOL twoClickAvailable = [[self.info.creditCard.savedCards filteredArrayUsingPredicate:twoClickPredicateFilter] count] > 0;
    [[NSUserDefaults standardUserDefaults] setObject:@(oneClickAvailable) forKey:MIDTRANS_TRACKING_ONE_CLICK_AVAILABLE];
    [[NSUserDefaults standardUserDefaults] setObject:@(twoClickAvailable) forKey:MIDTRANS_TRACKING_TWO_CLICK_AVAILABLE];
    [[MIDUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:@{@"1 click token available": @(oneClickAvailable), @"2 clicks token available": @(twoClickAvailable)}];
}
- (void)totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    if (!self.selectedPromos) {
        [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.info.items];
    } else {
        [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.info.items WithPromoSelected:self.selectedPromos];
    }
    
}

- (MIDPromoInfo *)promoInfo {
    return self.info.promo;
}

- (void)deleteCardPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.title"]
                                                                   message:[VTClassHelper getTranslationFromAppBundleForString:@"alert.message-delete-card"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.no"]
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.yes"]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action)
                          {
                              [self deleteSavedCard];
                          }];
    [alert addAction:cancel];
    [alert addAction:yes];
    
    [self presentViewController:alert animated:yes completion:nil];
}

- (void)deleteSavedCard {
    [self showLoadingWithText:nil];
    [MIDCreditCardCharge deleteSavedCard:self.savedCardInfo.maskedCard snapToken:self.snapToken completion:^(id  _Nullable result, NSError * _Nullable error) {
        [self hideLoading];
        if ([self.delegate respondsToSelector:@selector(didDeleteSavedCard)]) {
            [self.delegate didDeleteSavedCard];
        }
    }];
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
    }
    else {
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
    if (number.length == 0) {
        [self.promoArray removeAllObjects];
        [self.promoArray addObjectsFromArray:self.currentPromo];
    } else {
        self.currentPromoSelected = @"";
        self.currentPromoIndex = nil;
        self.prevPromoIndex = nil;
        
        NSArray *filtered = [self.promoInfo.promos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"bins CONTAINS [cd] %@", [NSString stringWithFormat:@"%@", number]]];
        
        if (filtered.count) {
            [self.promoArray removeAllObjects];
            [self updatePromoContent];
        } else {
            [self updatePromoContent];
        }
        for (MIDPromo *promo in filtered) {
            AddOnConstructor *promoConstructor = [[AddOnConstructor alloc] initWithDictionary:@{
                                                                                                @"addOnName":SNP_PROMO,
                                                                                                @"addOnTitle":promo.name,
                                                                                                @"addOnDescriptions":promo.calculatedDiscountAmount,
                                                                                                @"addOnAdditional":promo.promoID
                                                                                                }];
            [self.promoArray addObject:promoConstructor];
        }
    }
    [self updatePromoContent];
    
}

- (void)updateCreditCardTextFieldInfoWithNumber:(NSString *)number {
    if ([self.info.merchant.enabledPrinciples containsObject:[[MIDCreditCardHelper nameFromString:number] lowercaseString]]) {
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
        NSInteger totalOrder = self.info.transaction.grossAmount.integerValue - [constructor.addOnDescriptions integerValue];
        NSNumber *castingNumber  = [NSNumber numberWithInteger:totalOrder];
        self.selectedPromos = constructor;
        self.view.totalAmountPrice.text =castingNumber.formattedCurrencyNumber;
    } else {
        self.view.totalAmountPrice.text = self.info.transaction.grossAmount.formattedCurrencyNumber;
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
            self.filteredBinObject = [[MIDBinResponse alloc] initWithDictionary:[filtered firstObject]];
            if (filtered.count > 1) {
                NSArray *debitCard  = [filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF['bank'] CONTAINS 'debit'"]];
                if (debitCard.count) {
                    MIDBinResponse *debitCardObject = [[MIDBinResponse alloc] initWithDictionary:[debitCard firstObject]];
                    if ([debitCardObject.bank containsString:SNP_CORE_BANK_MANDIRI]) {
                        isDebitCard = YES;
                        self.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.Mandiri Debit Card"];
                        self.filteredBinObject.bank = SNP_CORE_BANK_MANDIRI;
                        if ([self.info.merchant.pointBanks containsObject:SNP_CORE_BANK_MANDIRI]) {
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
                        if ([self.info.merchant.pointBanks containsObject:SNP_CORE_BANK_MANDIRI]) {
                            if (![self.addOnArray containsObject:self.constructMandiriPoint]) {
                                [self.addOnArray addObject:self.constructMandiriPoint];
                                [self updateAddOnContent];
                            }
                        }
                    }
                    if ([self.filteredBinObject.bank isEqualToString:SNP_CORE_BANK_BNI]) {
                        if ([self.info.merchant.pointBanks containsObject:SNP_CORE_BANK_BNI] ) {
                            if (![self.addOnArray containsObject:self.constructBNIPoint]) {
                                [self.addOnArray addObject:self.constructBNIPoint];
                                [self updateAddOnContent];
                            }
                        }
                        
                    }
                }
            }
            
            if (self.installmentAvailable) {
                if ([self.filteredBinObject.bank isEqualToString:@"other"]) {
                    self.installmentBankName = @"offline";
                }
                else {
                    self.installmentBankName = self.filteredBinObject.bank;
                }
                
                [self.installmentValueObject setArray:@[@"0"]];
                [self.installmentValueObject addObjectsFromArray:[self.installmentInfo.terms objectForKey:self.installmentBankName]];
                [self showInstallmentView:YES];
            }
        }
        else {
            self.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.input.title"];
            if ([[self.installmentInfo.terms objectForKey:@"offline"] count]) {
                if (!isDebitCard) {
                    self.installmentBankName = @"offline";
                    [self.installmentValueObject setArray:@[@"0"]];
                    [self.installmentValueObject addObjectsFromArray:[self.installmentInfo.terms objectForKey:self.installmentBankName]];
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
        self.filteredBinObject.bank = @"";
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
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.installmentAvailable) forKey:MIDTRANS_TRACKING_INSTALLMENT_AVAILABLE];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.installmentRequired) forKey:MIDTRANS_TRACKING_INSTALLMENT_REQUIRED];
    NSMutableDictionary *additionalData = [NSMutableDictionary dictionaryWithDictionary:@{@"installment available": @(self.installmentAvailable), @"installment required": @(self.installmentRequired)}];
    if (self.info.transaction.orderID) {
        [additionalData addEntriesFromDictionary:@{@"order id": self.info.transaction.orderID}];
    }
    [[MIDUITrackingManager shared] trackEventName:@"btn confirm payment" additionalParameters:additionalData];
    if (self.installmentAvailable && self.installmentCurrentIndex !=0 && !self.bniPointActive && !self.mandiriPointActive) {
        self.installmentTerms = [NSString stringWithFormat:@"%@_%@",self.installmentBankName,
                                 [[self.installmentInfo.terms  objectForKey:self.installmentBankName] objectAtIndex:self.installmentCurrentIndex -1]];
    }
    
    if (self.installmentRequired && self.installmentCurrentIndex == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:[VTClassHelper getTranslationFromAppBundleForString:@"This transaction must use installment"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"] style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString *cardNumber;
    
    if (self.savedCardInfo) {
        cardNumber = self.savedCardInfo.maskedCard;
    }
    else {
        MIDCreditCardModel *cc = [[MIDCreditCardModel alloc] initWithNumber:self.view.creditCardNumberTextField.text
                                                                 expiryDate:self.view.cardExpireTextField.text
                                                                        cvv:self.view.cardCVVNumberTextField.text];
        NSError *error = nil;
        if ([cc isValidCreditCard:&error] == NO) {
            [self handleRegisterCreditCardError:error];
            return;
        }
        cardNumber = cc.number;
        
    }
    
    if (self.blackListBins.count) {
        NSError *error;
        if ([MIDCreditCardHelper isCreditCardNumber:cardNumber containBlacklistBins:self.blackListBins error:&error]) {
            [self.view isViewableError:error];
            return;
        }
    }
    
    if (self.bins.count) {
        NSError *error;
        if (![MIDCreditCardHelper isCreditCardNumber:cardNumber eligibleForBins:self.bins error:&error] &&
            ![MIDCreditCardHelper isCreditCardNumber:self.filteredBinObject.bank eligibleForBins:self.bins error:&error]) {
            [self.view isViewableError:error];
            return;
        }
    }
    
    if (!self.view.cardCVVNumberTextField.text.length) {
        self.view.cardCVVNumberTextField.warning = [VTClassHelper getTranslationFromAppBundleForString:@"CVV is invalid"];
        return;
    }
    
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    
    MIDTokenizeConfig *config = [MIDTokenizeConfig new];
    config.enable3ds = self.info.creditCard.secure;
    
    if (self.selectedPromos){
        NSInteger totalOrder = self.info.transaction.grossAmount.integerValue - [self.selectedPromos.addOnDescriptions integerValue];
        config.grossAmount = [NSNumber numberWithInteger:totalOrder];
    } else {
        config.grossAmount = self.info.transaction.grossAmount;
    }
    
    if (self.installmentTerms && self.installmentCurrentIndex !=0) {
        NSInteger installment = [self.installmentInfo.terms[self.installmentBankName][self.installmentCurrentIndex-1] integerValue];
        config.installmentTerm = installment;
    }
    
    if (self.bniPointActive || self.mandiriPointActive) {
        config.enablePoint = YES;
    }
    
    NSString *CVV = self.view.cardCVVNumberTextField.text;
    if (self.savedCardInfo) {
        [MIDCreditCardTokenizer tokenizeCardToken:self.savedCardInfo.token
                                              cvv:CVV
                                           config:config
                                       completion:^(MIDTokenizeResponse * _Nullable token, NSError * _Nullable error)
         {
             [self handleTokenizeResult:error response:token pointEnabled:config.enablePoint];
         }];
        
    } else {
        NSArray *dates = [self.view.cardExpireTextField.text componentsSeparatedByString:@" / "];
        NSString *expMonth = dates[0];
        NSString *expYear = dates.count == 2 ? dates[1] : nil;
        [MIDCreditCardTokenizer tokenizeCardNumber:cardNumber
                                               cvv:CVV
                                       expireMonth:expMonth
                                        expireYear:expYear
                                            config:config
                                        completion:^(MIDTokenizeResponse * _Nullable token, NSError * _Nullable error)
         {
             [self handleTokenizeResult:error response:token pointEnabled:config.enablePoint];
         }];
    }
}

- (void)handleTokenizeResult:(NSError *)error response:(MIDTokenizeResponse *)response pointEnabled:(BOOL)pointEnabled {
    if (error) {
        [self hideLoading];
        [self handleTransactionError:error];
    }
    else {
        _cardTokenID = response.tokenID;
        
        if (pointEnabled) {
            SNPPointViewController *pointVC = [[SNPPointViewController alloc] initWithPaymentMethod:self.paymentMethod cardToken:response.tokenID];
            pointVC.isSaveCard = self.isSaveCard;
            pointVC.secureURL = response.secureURL;
            
            if (self.bniPointActive) {
                pointVC.bankName = SNP_CORE_BANK_BNI;
            }
            else if (self.mandiriPointActive) {
                pointVC.bankName = SNP_CORE_BANK_MANDIRI;
            }
            
            [self.navigationController pushViewController:pointVC animated:YES];
            
            [self hideLoading];
        }
        else {
            if (response.secureURL) {
                [self hideLoading];
                
                MID3DSController *vc = [[MID3DSController alloc] initWithURL:[NSURL URLWithString:response.secureURL]];
                vc.delegate = self;
                [self presentViewController:vc animated:YES completion:nil];
            }
            else {
                [self payWithToken:response.tokenID];
            }
        }
    }
}

- (void)payWithToken:(NSString *)token {
    if (self.view.contactPhoneNumberTextField.text.length > 0) {
        self.info.customer.phone = self.view.contactPhoneNumberTextField.text;
    }
    
    if (self.view.contactEmailTextField.text.length > 0) {
        self.info.customer.email = self.view.contactEmailTextField.text;
    }
    
    MIDPromoOption *promo;
    if (self.selectedPromos){
        if (self.selectedPromos.addOnAddtional) {
            MIDPromo *_promo = self.info.promo.promos[self.currentPromoIndex.integerValue];
            promo = [[MIDPromoOption alloc] initWithPromoID:_promo.promoID discountedGrossAmount:_promo.discountedGrossAmount];
        }
    }
    
    if (self.bniPointActive || self.mandiriPointActive) {
        SNPPointViewController *pointVC = [[SNPPointViewController alloc] initWithPaymentMethod:self.paymentMethod cardToken:token];
        
        if (self.bniPointActive) {
            pointVC.bankName = SNP_CORE_BANK_BNI;
        }
        else if (self.mandiriPointActive) {
            pointVC.bankName = SNP_CORE_BANK_MANDIRI;
        }
        [self.navigationController pushViewController:pointVC animated:YES];
        return;
    }
    
    MIDChargeInstallment *installment;
    if (self.installmentTerms && self.installmentCurrentIndex !=0) {
        NSInteger term = [self.installmentInfo.terms[self.installmentBankName][self.installmentCurrentIndex-1] integerValue];
        installment = [[MIDChargeInstallment alloc] initWithBank:[self.installmentBankName acquiringBank] term:term];
    }
    
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    
    [MIDCreditCardCharge chargeWithToken:self.snapToken
                               cardToken:token
                                    save:self.isSaveCard
                             installment:installment
                                   point:nil
                                   promo:promo
                              completion:^(MIDCreditCardResult * _Nullable result, NSError * _Nullable error)
     {
         
         [self hideLoading];
         
         if (error) {
             if (self.attemptRetry < 2) {
                 self.attemptRetry += 1;
                 
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:error.localizedMidtransErrorMessage preferredStyle:UIAlertControllerStyleAlert];
                 [alert addAction:[UIAlertAction actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"] style:UIAlertActionStyleDefault handler:nil]];
                 [self presentViewController:alert animated:YES completion:nil];
             }
             else {
                 [self handleTransactionError:error];
             }
         }
         else {
             if ([result.fraudStatus isEqualToString:@"challenge"]) {
                 if (result.statusCode == 201) {
                     [self handleRBATransactionWithTransactionResult:result];
                 }
                 else {
                     [self handleTransactionSuccess:result];
                 }
             }
             else {
                 if ([result.transactionStatus isEqualToString:MIDTRANS_TRANSACTION_STATUS_DENY] && self.attemptRetry<2) {
                     self.attemptRetry+=1;
                     
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:[VTClassHelper getTranslationFromAppBundleForString:result.codeForLocalization] preferredStyle:UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"] style:UIAlertActionStyleDefault handler:nil]];
                     [self presentViewController:alert animated:YES completion:nil];
                 }
                 else {
                     if (result.statusCode == 201) {
                         [self handleRBATransactionWithTransactionResult:result];
                     }
                     else {
                         [self handleTransactionSuccess:result];
                     }
                 }
             }
         }
     }];
}

-(void)handleRBATransactionWithTransactionResult:(MIDCreditCardResult *)result  {
    MID3DSController *vc = [[MID3DSController alloc] initWithURL:[NSURL URLWithString:result.RBAURL]];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)secureAuthenticationRBASuccess:(MID3DSController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    [self showLoadingWithText:nil];
    
    [MIDClient getPaymentStatusWithToken:self.snapToken completion:^(MIDPaymentResult * _Nullable result, NSError * _Nullable error) {
        [self hideLoading];
        
        if (result) {
            [self handleTransactionSuccess:result];
        } else {
            [self handleTransactionError:error];
        }
    }];
}

- (void)secureAuthenticationSuccess:(MID3DSController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self payWithToken:_cardTokenID];
}

- (void)secureAuthenticationError:(MID3DSController *)viewController error:(NSError *)error {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self handleTransactionError:error];
}

- (void)handleRegisterCreditCardError:(NSError *)error {
    if ([self.view isViewableError:error] == NO) {
        [self showAlertViewWithTitle:@"Error"
                          andMessage:error.localizedMidtransErrorMessage
                      andButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]];
    }
}

-(void)installmentSelectedIndex:(NSInteger)index {
    self.installmentCurrentIndex = index;
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
            switch ([MIDCreditCardHelper typeFromString:ccnumber]) {
                case MIDCreditCardTypeAmex:
                    if (ccnumber.length == 15) {
                        return;
                        // [self.view.cardExpireTextField becomeFirstResponder];
                    }
                    break;
                case MIDCreditCardTypeJCB:
                case MIDCreditCardTypeVisa:
                case MIDCreditCardTypeMasterCard:
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
        else if ([MIDCreditCardHelper typeFromString:ccnumber] == MIDCreditCardTypeAmex) {
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
