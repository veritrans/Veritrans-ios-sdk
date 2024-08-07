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

static NSString *const kCardTypeDebit = @"DEBIT";
static NSString *const kCardTypeCredit = @"CREDIT";
static NSString *const kInstallmentChannelOffline = @"offline";
static NSString *const kInstallmentChannelOnline = @"online";
static NSString *const kInstallmentChannelOnlineOffline = @"online_offline";

@interface MidtransNewCreditCardViewController () <
UITableViewDelegate,
UITableViewDataSource,
MidtransUITextFieldDelegate,
MidtransUICardFormatterDelegate,
MidtransInstallmentViewDelegate,
Midtrans3DSControllerDelegate,
MidtransCommonTSCViewControllerDelegate
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
@property (nonatomic,strong) NSNumber *totalGrossAmount;
@property (nonatomic,strong) MidtransPaymentCreditCard *paymentDetail;
@property (nonatomic) UIImage *bankIcon;
@property (nonatomic) MIDExbinData *binData;
@property (nonatomic) NSString *requestedNumber;
@property (nonatomic) NSArray *binDataArray;
@property (nonatomic) BOOL isBinDataFoundOnCache;
@property (nonatomic) BOOL isBinMatchWithPromo; 
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
    
    self.bniPointActive = NO;
    self.mandiriPointActive = NO;
    self.installmentCurrentIndex = 0;
    self.installmentAvailable = NO;
    self.installmentValueObject = [NSMutableArray new];
    self.installmentBankName = @"";
    self.view.creditCardNumberTextField.delegate = self;
    self.view.cardCVVNumberTextField.delegate = self;
    self.view.cardExpireTextField.delegate = self;
    self.view.contactPhoneNumberTextField.delegate = self;
    self.view.contactEmailTextField.delegate = self;
    [self addNavigationToTextFields:@[self.view.creditCardNumberTextField,
                                      self.view.cardExpireTextField,
                                      self.view.cardCVVNumberTextField,
                                      self.view.contactPhoneNumberTextField,
                                      self.view.contactEmailTextField
    ]];
    
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
    self.view.promoTableView.rowHeight = UITableViewAutomaticDimension;
    self.view.promoTableView.estimatedRowHeight = 44;
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
    
    self.isSaveCard = self.responsePayment.creditCard.saveCard;
    self.showUserForm = [CC_CONFIG showFormCredentialsUser];
    self.view.userDetailViewWrapper.hidden = YES;
    self.view.userDetailViewWrapperConstraints.constant = 0.0f;
    self.view.contactEmailTextField.text = self.responsePayment.customerDetails.email;
    self.view.contactPhoneNumberTextField.text = self.responsePayment.customerDetails.phone;
    if (self.showUserForm) {
        self.view.contactEmailTextField.text = self.responsePayment.customerDetails.email;
        self.view.contactPhoneNumberTextField.text = self.responsePayment.customerDetails.phone;
        self.view.userDetailViewWrapper.hidden = NO;
        self.view.userDetailViewWrapperConstraints.constant = 150.0f;
    }
    if (self.responsePayment.creditCard.saveCard && (self.maskedCreditCard == nil)) {
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
    
    if (self.promos) {
        if (self.promos.promos.count) {
            self.promoAvailable = YES;
            [self updatePromoViewWithCreditCardNumber:nil];
        }
    }
    
    if (self.installment.terms) {
        self.installmentAvailable = YES;
        self.installmentRequired = self.installment.required;
        [self setupInstallmentView];
    }
    [[SNPUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:@{@"installment available": @(self.installmentAvailable), @"installment required": @(self.installmentRequired)}];
    
    self.bins = self.creditCardInfo.whitelistBins;
    self.blackListBins = self.creditCardInfo.blacklistBins;
    
    if (self.maskedCreditCard) {
        self.view.creditCardNumberTextField.text = self.maskedCreditCard.formattedNumber;
        self.view.cardExpireTextField.text = @"\u2022\u2022 / \u2022\u2022";
        self.view.creditCardNumberTextField.enabled = NO;
        self.view.cardExpireTextField.enabled = NO;
        self.bankIcon = [self.view iconWithBankName:self.bankName];
        self.view.creditCardNumberTextField.info2Icon = self.bankIcon;
        if (self.tokenType == MTCreditCardPaymentTypeOneclick) {
            self.view.cardCVVNumberTextField.text = @"***";
        }
        [self updateCreditCardAttributes:self.maskedCreditCard.maskedNumber];
        
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
        [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails grossAmount:self.token.transactionDetails.grossAmount];
    } else {
        [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails WithPromoSelected:self.selectedPromos grossAmount:self.token.transactionDetails.grossAmount];
    }
}

- (IBAction)scanCardTapped:(id)sender {
    
}

- (void)deleteCardPressed:(id)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.title"]
                                message:[VTClassHelper getTranslationFromAppBundleForString:@"alert.message-delete-card"]
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noButton = [UIAlertAction
                               actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.no"]
                               style:UIAlertActionStyleDefault
                               handler:nil];
    UIAlertAction *yesButton = [UIAlertAction
                                actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.yes"]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
        [self confirmedDeleteSavedCard];
    }];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) confirmedDeleteSavedCard {
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
    }
}

- (void) setupInstallmentView {
    self.installmentsContentView = [[VTBundle loadNibNamed:@"MidtransInstallmentView" owner:self options:nil] firstObject];
    self.installmentsContentView.delegate = self;
    self.installmentsContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view.installmentView addSubview:self.installmentsContentView];
    NSDictionary *views = @{@"view":self.installmentsContentView};
    [self.view.installmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:0 views:views]];
    [self.view.installmentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:0 views:views]];
    [self.installmentsContentView setupInstallmentCollection];
}


- (double) calculateDiscountPromo:(MidtransPromo *)promo {
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
        } else if ([payAddOn.addOnName isEqualToString:SNP_CORE_BNI_POINT]) {
            cell.checkButton.selected = self.bniPointActive;
            return cell;
        } else if ([payAddOn.addOnName isEqualToString:SNP_CORE_MANDIRI_POINT]) {
            cell.checkButton.selected = self.mandiriPointActive;
            return cell;
        } else {
            if(indexPath.row == [self.currentPromoIndex integerValue]){
                cell.checkButton.selected = !cell.checkButton.selected;
            }
            return cell;
        }
    } else {
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

- (void)updateAddOnContent {
    self.view.addOnTableViewHeightConstraints.constant = self.addOnArray.count * 50;
    [self.view.addOnTableView reloadData];
}
- (void)updatePromoContent {
    self.view.promoTableViewHeightConstraints.constant = self.promoArray.count * 50;
    [self.view.promoTableView reloadData];
}
- (void)updatePromoViewWithCreditCardNumber:(NSString *)number {
    if (self.promoAvailable) {
        if (number.length == 0) {
            [self.promoArray removeAllObjects];
            if (self.currentPromo.count) {
                [self.promoArray addObjectsFromArray:self.currentPromo];
            } else {
                for (MidtransPromoPromos *promos in self.promos.promos) {
                    AddOnConstructor *promoConstructor = [[AddOnConstructor alloc] initWithDictionary:@{
                        @"addOnName":SNP_PROMO,
                        @"addOnTitle":promos.name,
                        @"addOnDescriptions":[NSString stringWithFormat:@"%0.f",promos.calculatedDiscountAmount],
                        @"addOnAdditional":[NSString stringWithFormat:@"%0.f",promos.promosIdentifier]
                    }];
                    [self.promoArray addObject:promoConstructor];
                }
                [self.currentPromo addObjectsFromArray:self.promoArray];
            }
        } else {
            [self.promoArray removeAllObjects];
            [self updateAmountTotal:[AddOnConstructor new]];
            self.currentPromoSelected = @"";
            self.currentPromoIndex = nil;
            self.prevPromoIndex = nil;
            for (MidtransPromoPromos *promos in self.promos.promos) {
                AddOnConstructor *promoConstructor = [[AddOnConstructor alloc] initWithDictionary:@{
                    @"addOnName":SNP_PROMO,
                    @"addOnTitle":promos.name,
                    @"addOnDescriptions":[NSString stringWithFormat:@"%0.f",promos.calculatedDiscountAmount],
                    @"addOnAdditional":[NSString stringWithFormat:@"%0.f",promos.promosIdentifier]
                }];
                self.isBinMatchWithPromo = NO;
                if (promos.bins.count) {
                    for (NSString* bins in promos.bins  ) {
                        if (number.length >= bins.length) {
                            if ([[number substringToIndex:bins.length] isEqualToString:bins]) {
                                self.isBinMatchWithPromo = YES;
                            }
                        } else if (bins.length >= number.length){
                            if ([[bins substringToIndex:number.length] isEqualToString:number]) {
                                self.isBinMatchWithPromo = YES;
                            }
                        }
                    }
                } else {
                    self.isBinMatchWithPromo = YES;
                }
                if (self.isBinMatchWithPromo) {
                    [self.promoArray addObject:promoConstructor];
                }
            }
        }
        [self updatePromoContent];
    }
}

- (void)getCrediCardBinData:(NSString *)number {
    NSString *binNumber =  [number substringToIndex:MIDTRANS_SUPPORTED_BIN_LENGTH];
    self.isBinDataFoundOnCache = NO;
        if( [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_EXBIN_DATA] != nil) {
            self.binDataArray = [NSArray arrayWithArray:[self loadCustomObjectWithKey:MIDTRANS_EXBIN_DATA]];
            for (MIDExbinData * bindata in self.binDataArray) {
                if ([binNumber isEqualToString:bindata.bin]) {
                    self.binData = bindata;
                    self.isBinDataFoundOnCache = YES;
                    break;
                }
            }
        }
    
    if (self.isBinDataFoundOnCache) {
        [self updateCreditCardBankIcon];
    } else {
        [[MidtransClient shared] requestBINDataWithNumber:binNumber completion:^(MIDExbinResponse * _Nullable binResponse, NSError * _Nullable error) {
            if (binResponse) {
                self.binData = binResponse.data;
                [self saveBinDataToCache:binResponse.data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateCreditCardBankIcon];
                });
            }
        }];
    }
}

- (void)updateCreditCardBankIcon{
    self.bankIcon = [self.view iconWithBankName:self.binData.bankCode];
    [self setupCreditCardBankIcon:self.bankIcon];
}

- (void)saveBinDataToCache:(MIDExbinData *)binData{
    
    NSMutableArray *binDataArray = [[NSMutableArray alloc]init];
    [binDataArray addObject:binData];

    if( [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_EXBIN_DATA] != nil) {
        [binDataArray addObjectsFromArray:[self loadCustomObjectWithKey:MIDTRANS_EXBIN_DATA]];
    }
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:binDataArray];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:MIDTRANS_EXBIN_DATA];
}

- (NSArray *)loadCustomObjectWithKey:(NSString *)key{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

- (void)setupCreditCardBankIcon:(UIImage *)icon {
    self.view.creditCardNumberTextField.info2Icon = icon;
    [self.view.creditCardNumberTextField layoutSubviews];
}

#pragma mark - VTCardFormatterDelegate

- (void)formatter_didTextFieldChange:(MidtransUICardFormatter *)formatter {
    NSString *originNumber = [self.view.creditCardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]; 
    [self updateCreditCardAttributes:originNumber];
    
}

- (void)updateCardPrincipleIcon:(NSString*)number {
    if ([self.responsePayment.merchant.enabledPrinciples containsObject:[[MidtransCreditCardHelper nameFromString:number] lowercaseString]]) {
        self.view.creditCardNumberTextField.info1Icon = [self.view iconDarkWithNumber:number];
    }
    else {
        [self resetCardPrincipleIconToInitialState];
    }
}

- (void)resetCardPrincipleIconToInitialState {
    self.view.creditCardNumberTextField.info1Icon = nil;
}

- (void)updateCreditCardAttributes:(NSString *)number{
    [self updateCardPrincipleIcon:number];
    if (number.length >= MIDTRANS_SUPPORTED_BIN_LENGTH) {
        [self getCrediCardBinData:number];
        [self checkBankPoint];
        [self checkInstallment];
    } else if (number.length < MIDTRANS_SUPPORTED_BIN_LENGTH) {
        self.bankIcon = nil;
        self.view.creditCardNumberTextField.info2Icon = self.bankIcon;
        [self resetPointToInitialState];
        [self resetInstallmentToInitialState];
    }
    [self updatePromoViewWithCreditCardNumber:number];
}

- (void)checkBankPoint {
    if ([self.binData.binType isEqualToString:kCardTypeCredit] && (self.tokenType != MTCreditCardPaymentTypeOneclick) && self.creditCardInfo.secure){
        
        if ([self.binData.bankCode.lowercaseString isEqualToString:SNP_CORE_BANK_MANDIRI]) {
            if ([self.responsePayment.merchant.pointBanks containsObject:SNP_CORE_BANK_MANDIRI]) {
                if (![self.addOnArray containsObject:self.constructMandiriPoint]) {
                    [self.addOnArray addObject:self.constructMandiriPoint];
                    [self updateAddOnContent];
                }
            }
        }
        if ([self.binData.bankCode.lowercaseString isEqualToString:SNP_CORE_BANK_BNI]) {
            if ([self.responsePayment.merchant.pointBanks containsObject:SNP_CORE_BANK_BNI]) {
                if (![self.addOnArray containsObject:self.constructBNIPoint]) {
                    [self.addOnArray addObject:self.constructBNIPoint];
                    [self updateAddOnContent];
                }
            }
        }
    }
}

- (void)resetPointToInitialState{
    if ([self.addOnArray containsObject:self.constructBNIPoint]) {
        [self.addOnArray removeObject:self.constructBNIPoint];
        [self updateAddOnContent];
    }
    if ([self.addOnArray containsObject:self.constructMandiriPoint]) {
        [self.addOnArray removeObject:self.constructMandiriPoint];
        [self updateAddOnContent];
    }
}
- (void)resetInstallmentToInitialState {
    if (self.installmentValueObject.count > 0) {
        self.installmentCurrentIndex = 0;
        [self.installmentValueObject removeAllObjects];
        [self.installmentsContentView resetInstallmentIndex];
    }
    [self showInstallmentView:NO];
}


- (void)checkInstallment{
    if (self.installmentAvailable) {
        if (self.installment.terms[@"offline"]) {
            self.installmentBankName = @"offline";
        }
        else {
            self.installmentBankName = self.binData.bankCode.lowercaseString;
        }
        
        if (![self.binData.binType.lowercaseString isEqualToString:kCardTypeDebit]) {
            [self.installmentValueObject setArray:@[@"0"]];
            [self.installmentValueObject addObjectsFromArray:[self.installment.terms objectForKey:self.installmentBankName]];
            [self showInstallmentView:YES];
        }
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
        if (self.mandiriPointActive) {
            [self showInstallmentView:NO];
        } else {
            [self showInstallmentView:YES];
        }
        [self.view.addOnTableView reloadData];
    }
    else if ([constructor.addOnName isEqualToString:SNP_CORE_BNI_POINT]) {
        self.bniPointActive = !sender.selected;
        if (self.bniPointActive) {
            [self openCommonTSCWithBank:SNP_CORE_BNI_POINT];
            [self showInstallmentView:NO];
        } else {
            [self showInstallmentView:YES];
        }
        [self.view.addOnTableView reloadData];
    }
    
}
- (void)updateAmountTotal:(AddOnConstructor *)constructor{
    if (constructor){
        NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [constructor.addOnDescriptions integerValue];
        self.totalGrossAmount  = [NSNumber numberWithInteger:totalOrder];
        self.selectedPromos = constructor;
        self.view.totalAmountPrice.text = self.totalGrossAmount.formattedCurrencyNumber;
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
                                                          message:[VTClassHelper getTranslationFromAppBundleForString:@"You can pay partly through the redemption of Mandiri Fiestpoin through your Mandiri credit / debit card"]
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

- (BOOL) isValidCreditCardDataForm {
    NSError *error;
    if ([self.view.creditCardNumberTextField.text SNPisEmpty]){
        [self.view.creditCardNumberTextField.text isValidCreditCardNumber:&error];
    }
    else if ([self.view.cardExpireTextField.text SNPisEmpty]) {
        [self.view.cardExpireTextField.text isValidExpiryDate:&error];
    }
    else if ([self.view.cardCVVNumberTextField.text SNPisEmpty]){
        [self.view.cardCVVNumberTextField.text isValidCVVWithCreditCardNumber:self.view.cardCVVNumberTextField.text error:&error];
    }
    if (error) {
        [self.view isViewableError:error];
        return NO;
    } else {
        return YES;
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

- (void)showInstallmentView:(BOOL)show {
    [UIView transitionWithView:self.view.installmentView
                      duration:1
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.view.installmentView.hidden = !show;
            [self.installmentsContentView.installmentCollectionView reloadData];
        });
        [self.installmentsContentView configureInstallmentView:self.installmentValueObject isInstallmentRequired:self.installmentRequired];
    }
                    completion:NULL];
}

- (IBAction)submitPaymentDidtapped:(id)sender {
    if (![self isValidCreditCardDataForm]) {
        return;
    } else {
        [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
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
            [self hideLoading];
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"ERROR"
                                        message:[VTClassHelper getTranslationFromAppBundleForString:@"This transaction must use installment"]
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction
                                           actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
                                           style:UIAlertActionStyleDefault
                                           handler:nil];
            [alert addAction:cancelButton];
            [self presentViewController:alert animated:YES completion:nil];
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
                [self hideLoading];
                return;
            }
            cardNumber = creditCard.number;
            
        }
        
        if (self.blackListBins.count) {
            NSError *error;
            if ([MidtransClient isCreditCardNumber:cardNumber containBlacklistBins:self.blackListBins error:&error]) {
                [self hideLoading];
                [self.view isViewableError:error];
                return;
            }
        }
        
        if (self.bins.count) {
            NSError *error;
            if (![MidtransClient isCreditCardNumber:cardNumber eligibleForBins:self.bins error:&error] &&
                ![MidtransClient isCreditCardNumber:self.filteredBinObject.bank eligibleForBins:self.bins error:&error]) {
                [self hideLoading];
                [self.view isViewableError:error];
                return;
            }
        }
        
        MidtransTokenizeRequest *tokenRequest;
        
        if (self.maskedCreditCard) {
            if (!self.view.cardCVVNumberTextField.text.length) {
                [self hideLoading];
                return;
            }
            
            if (self.selectedPromos){
                NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [self.selectedPromos.addOnDescriptions integerValue];
                self.totalGrossAmount = [NSNumber numberWithInteger:totalOrder];
                tokenRequest = [[MidtransTokenizeRequest alloc]initWithCreditCardToken:self.maskedCreditCard.savedTokenId cvv:self.view.cardCVVNumberTextField.text grossAmount:self.totalGrossAmount secure:self.responsePayment.creditCard.secure paymentTokenType:self.tokenType];
            } else {
                tokenRequest = [[MidtransTokenizeRequest alloc]initWithCreditCardToken:self.maskedCreditCard.savedTokenId cvv:self.view.cardCVVNumberTextField.text grossAmount:self.token.transactionDetails.grossAmount secure:self.responsePayment.creditCard.secure paymentTokenType:self.tokenType];
            }
        }
        else {
            
            if (self.selectedPromos){
                NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [self.selectedPromos.addOnDescriptions integerValue];
                self.totalGrossAmount  = [NSNumber numberWithInteger:totalOrder];
                tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                       grossAmount:self.totalGrossAmount];
            } else {
                tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                                       grossAmount:self.token.transactionDetails.grossAmount];
            }
            
        }
        
        if (self.installmentTerms && self.installmentCurrentIndex !=0) {
            NSInteger installment = [self.installment.terms[self.installmentBankName][self.installmentCurrentIndex-1] integerValue];
            tokenRequest.installment = YES;
            tokenRequest.installmentTerm = @(installment);
        }
        if (self.bniPointActive || self.mandiriPointActive) {
            tokenRequest.point = YES;
            [[MidtransClient shared] generateToken:tokenRequest
                                        completion:^(NSString * _Nullable token, NSError * _Nullable error) {
                if (error) {
                    [self hideLoading];
                    [self handleTransactionError:error];
                } else {
                    [self hideLoading];
                    if (self.view.contactPhoneNumberTextField.text.length > 0) {
                        self.token.customerDetails.phone = self.view.contactPhoneNumberTextField.text;
                    }
                    
                    if (self.view.contactEmailTextField.text.length > 0) {
                        self.token.customerDetails.email = self.view.contactEmailTextField.text;
                    }
                    
                    self.paymentDetail = [MidtransPaymentCreditCard modelWithToken:token
                                                                          customer:self.token.customerDetails
                                                                          saveCard:self.isSaveCard
                                                                       installment:self.installmentTerms];
                    
                    
                    MidtransTransaction *transaction = [[MidtransTransaction alloc]
                                                        initWithPaymentDetails:self.paymentDetail token:self.token];
                    
                    if (self.selectedPromos){
                        if (self.selectedPromos.addOnAddtional) {
                            NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [self.selectedPromos.addOnDescriptions integerValue];
                            self.totalGrossAmount  = [NSNumber numberWithInteger:totalOrder];
                            
                            NSDictionary *promoConstructor = @{@"discounted_gross_amount":self.totalGrossAmount,
                                                               @"promo_id":self.selectedPromos.addOnAddtional
                            };
                            
                            self.paymentDetail = [MidtransPaymentCreditCard modelWithToken:token
                                                                                  customer:self.token.customerDetails
                                                                                  saveCard:self.isSaveCard
                                                                               installment:self.installmentTerms
                                                                                    promos:promoConstructor];
                            transaction = [[MidtransTransaction alloc]
                                           initWithPaymentDetails:self.paymentDetail token:self.token];
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
                        pointVC.totalGrossAmount = self.totalGrossAmount;
                        pointVC.paymentDetails = self.paymentDetail;
                        pointVC.currentMaskedCards = self.currentMaskedCards;
                        [self.navigationController pushViewController:pointVC animated:YES];
                    }
                }
            }];
            return;
        }
        
        if (self.tokenType == MTCreditCardPaymentTypeOneclick) {
            [self payWithToken:self.token.tokenId];
        } else {
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
    }
}

- (void)payWithToken:(NSString *)token {
    if (self.view.contactPhoneNumberTextField.text.length > 0) {
        self.token.customerDetails.phone = self.view.contactPhoneNumberTextField.text;
    }
    
    if (self.view.contactEmailTextField.text.length > 0) {
        self.token.customerDetails.email = self.view.contactEmailTextField.text;
    }
    
    if (self.tokenType == MTCreditCardPaymentTypeOneclick) {
        NSDictionary *promoConstructor;
        if (self.selectedPromos){
            if (self.selectedPromos.addOnAddtional) {
                NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [self.selectedPromos.addOnDescriptions integerValue];
                NSNumber *castingNumber  = [NSNumber numberWithInteger:totalOrder];
                
                promoConstructor = @{@"discounted_gross_amount":castingNumber,
                                     @"promo_id":self.selectedPromos.addOnAddtional
                };
            }
        }
        self.paymentDetail = [MidtransPaymentCreditCard modelWithMaskedCard:self.maskedCreditCard.maskedNumber customer:self.token.customerDetails saveCard:NO installment:self.installmentTerms promos:promoConstructor];
    } else {
        self.paymentDetail = [MidtransPaymentCreditCard modelWithToken:token
                                                              customer:self.token.customerDetails
                                                              saveCard:self.isSaveCard
                                                           installment:self.installmentTerms];
        if (self.selectedPromos){
            if (self.selectedPromos.addOnAddtional) {
                NSInteger totalOrder = self.token.transactionDetails.grossAmount.integerValue - [self.selectedPromos.addOnDescriptions integerValue];
                NSNumber *castingNumber  = [NSNumber numberWithInteger:totalOrder];
                
                NSDictionary *promoConstructor = @{@"discounted_gross_amount":castingNumber,
                                                   @"promo_id":self.selectedPromos.addOnAddtional
                };
                
                self.paymentDetail = [MidtransPaymentCreditCard modelWithToken:token
                                                                      customer:self.token.customerDetails
                                                                      saveCard:self.isSaveCard
                                                                   installment:self.installmentTerms
                                                                        promos:promoConstructor];
            }
        }
    }
    
    MidtransTransaction *transaction = [[MidtransTransaction alloc]
                                        initWithPaymentDetails:self.paymentDetail token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error)
     {
        [self hideLoading];
        if (error) {
            if (self.attemptRetry < 2) {
                self.attemptRetry += 1;
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"ERROR"
                                            message:error.localizedDescription
                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelButton = [UIAlertAction
                                               actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
                                               style:UIAlertActionStyleDefault
                                               handler:nil];
                [alert addAction:cancelButton];
                [self presentViewController:alert animated:YES completion:nil];
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
                    UIAlertController *alert = [UIAlertController
                                                alertControllerWithTitle:@"ERROR"
                                                message:[VTClassHelper getTranslationFromAppBundleForString:result.codeForLocalization]
                                                preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelButton = [UIAlertAction
                                                   actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"]
                                                   style:UIAlertActionStyleDefault
                                                   handler:nil];
                    [alert addAction:cancelButton];
                    [self presentViewController:alert animated:YES completion:nil];
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
- (void)handleRBATransactionWithTransactionResult:(MidtransTransactionResult *)result
                             withTransactionData:(MidtransTransaction *)transaction  {
    
    Midtrans3DSController *secureController = [[Midtrans3DSController alloc]initWithToken:self.token.tokenId transactionResult:result transactionData:transaction];
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

- (void)installmentSelectedIndex:(NSInteger)index {
    self.installmentCurrentIndex = index;
    if (self.installmentCurrentIndex != 0) {
        if ([self.installmentBankName isEqualToString:SNP_CORE_BANK_BNI]){
            [self showBNIPoint:NO];
        } else if ([self.installmentBankName isEqualToString:SNP_CORE_BANK_MANDIRI])  {
            [self showMandiriPoint:NO];
        }
    } else {
        if ([self.installmentBankName isEqualToString:SNP_CORE_BANK_BNI]){
            [self showBNIPoint:YES];
        } else if ([self.installmentBankName isEqualToString:SNP_CORE_BANK_MANDIRI])  {
            [self showMandiriPoint:YES];
        }
    }
}

- (void)showMandiriPoint:(BOOL)show {
    if (show) {
        if (![self.addOnArray containsObject:self.constructMandiriPoint]) {
            [self.addOnArray addObject:self.constructMandiriPoint];
            [self updateAddOnContent];
        }
    } else {
        if ([self.addOnArray containsObject:self.constructMandiriPoint]) {
            [self.addOnArray removeObject:self.constructMandiriPoint];
            [self updateAddOnContent];
        }
    }
}

- (void)showBNIPoint:(BOOL)show {
    if (show) {
        if (![self.addOnArray containsObject:self.constructBNIPoint]) {
            [self.addOnArray addObject:self.constructBNIPoint];
            [self updateAddOnContent];
        }
    } else {
        if ([self.addOnArray containsObject:self.constructBNIPoint]) {
            [self.addOnArray removeObject:self.constructBNIPoint];
            [self updateAddOnContent];
        }
    }
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
