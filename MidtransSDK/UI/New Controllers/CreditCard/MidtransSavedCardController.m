//
//  MidtransSavedCardController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/2/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransSavedCardController.h"
#import "MidtransSavedCardCell.h"
#import "VTClassHelper.h"
#import "MidtransPaymentMethodHeader.h"
#import "MidtransNewCreditCardViewController.h"
#import "MidtransSavedCardFooter.h"
#import "MidtransTransactionDetailViewController.h"
#import "MIdtransUIBorderedView.h"
#import "VTConfirmPaymentController.h"
#import "MIDUITrackingManager.h"
#import "MIDVendorUI.h"

@interface MidtransSavedCardController () <UITableViewDelegate, UITableViewDataSource, MidtransNewCreditCardViewControllerDelegate>
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) MidtransPaymentMethodHeader *headerView;
@property (nonatomic) MidtransSavedCardFooter *footerView;
@property (nonatomic) NSArray *bankBinList;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountText;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@end

@implementation MidtransSavedCardController

- (NSString *)bankNameFromNumber:(NSString *)number {
    for (NSDictionary *bankBin in self.bankBinList) {
        NSString *bankName = bankBin[@"bank"];
        NSArray *bins = bankBin[@"bins"];
        for (NSString *bin in bins) {
            if ([number containsString:bin]) {
                return bankName;
            }
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:[VTBundle pathForResource:@"bin" ofType:@"json"]];
    self.bankBinList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    self.footerView = [[VTBundle loadNibNamed:@"MidtransSavedCardFooter" owner:self options:nil] lastObject];
    [self.footerView.addCardButton addTarget:self action:@selector(addCardPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.totalAmountLabel.text = [self.info.items formattedPriceAmount];
    self.orderIdLabel.text = self.info.transaction.orderID;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransSavedCardCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransSavedCardCell"];
    
    self.title = [VTClassHelper getTranslationFromAppBundleForString:@"creditcard.list.title"];
    [self.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    
    NSPredicate *oneClickPredicateFilter = [NSPredicate predicateWithFormat:@"%K like %@", NSStringFromSelector(@selector(type)), TokenTypeOneClick];
    BOOL oneClickAvailable = [[self.savedCards filteredArrayUsingPredicate:oneClickPredicateFilter] count] > 0;
    NSPredicate *twoClickPredicateFilter = [NSPredicate predicateWithFormat:@"%K like %@", NSStringFromSelector(@selector(type)), TokenTypeTwoClicks];
    BOOL twoClickAvailable = [[self.savedCards filteredArrayUsingPredicate:twoClickPredicateFilter] count] > 0;
    BOOL installmentRequired = self.info.creditCard.installment.required;
    BOOL installmentAvailable = self.info.creditCard.installment.terms.allKeys.count > 0;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(installmentAvailable) forKey:MIDTRANS_TRACKING_INSTALLMENT_AVAILABLE];
    [[NSUserDefaults standardUserDefaults] setObject:@(installmentRequired) forKey:MIDTRANS_TRACKING_INSTALLMENT_REQUIRED];
    NSDictionary *params = @{@"installment available": @(installmentAvailable),
                             @"installment required": @(installmentRequired),
                             @"1 click token available": @(oneClickAvailable),
                             @"2 clicks token available": @(twoClickAvailable)
                             };
    [[MIDUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:params];
}

- (NSArray <MIDSavedCardInfo *>*)savedCards {
    return self.info.creditCard.savedCards;
}

- (void)addCardPressed:(id)sender {
    NSMutableDictionary *additionalData = [NSMutableDictionary dictionaryWithDictionary:@{@"card mode":@"normal"}];
    if (self.info.transaction.orderID) {
        [additionalData addEntriesFromDictionary:@{@"order id":self.info.transaction.orderID}];
    }
    [[MIDUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:additionalData];
    
    MidtransNewCreditCardViewController *vc = [[MidtransNewCreditCardViewController alloc] initWithPaymentMethod:self.paymentMethod];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)performOneClickWithCard:(MIDSavedCardInfo *)card {
    if (self.info.transaction.orderID) {
        [[MIDUITrackingManager shared] trackEventName:@"btn confirm payment"
                                 additionalParameters:@{@"order id":self.info.transaction.orderID}];
    }
    
    [[MIDUITrackingManager shared] trackEventName:@"btn confirm payment"];
    VTConfirmPaymentController *vc = [[VTConfirmPaymentController alloc] initWithCardNumber:card.maskedCard
                                                                                grossAmount:self.info.transaction.grossAmount];
    
    [vc showOnViewController:self.navigationController clickedButtonsCompletion:^(NSUInteger selectedIndex) {
        if (selectedIndex == 1) {
            [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
            
            [MIDCreditCardCharge chargeWithToken:self.snapToken
                                       cardToken:card.token
                                            save:NO
                                     installment:nil
                                           point:nil
                                           promo:nil
                                      completion:^(MIDCreditCardResult * _Nullable result, NSError * _Nullable error)
             {
                 [self hideLoading];
                 
                 if (error) {
                     [self handleTransactionError:error];
                 } else {
                     [self handleTransactionSuccess:result];
                 }
             }];
        }
    }];
}

- (void)performTwoClicksWithCard:(MIDSavedCardInfo *)card {
    MidtransNewCreditCardViewController *vc = [[MidtransNewCreditCardViewController alloc] initWithPaymentMethod:self.paymentMethod];
    vc.savedCardInfo = card;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.savedCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransSavedCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MidtransSavedCardCell"];
    MIDSavedCardInfo *card = self.savedCards[indexPath.row];
    cell.maskedCard = card;
    cell.bankName = [self bankNameFromNumber:card.maskedCard];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MIDSavedCardInfo *card = self.savedCards[indexPath.row];
    
    if (CC_CONFIG.tokenStorageEnabled) {
        NSMutableDictionary *additionalData = [NSMutableDictionary dictionaryWithDictionary:@{@"card mode":@"two click"}];
        if (self.info.transaction.orderID) {
            [additionalData addEntriesFromDictionary:@{@"order id":self.info.transaction.orderID}];
        }
        [[MIDUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:additionalData];
        
        [self performTwoClicksWithCard:card];
    }
    else {
        if ([CC_CONFIG paymentType] == MTCreditCardPaymentTypeOneclick) {
            [self performOneClickWithCard:card];
        }
        else {
            NSMutableDictionary *additionalData = [NSMutableDictionary dictionaryWithDictionary:@{@"card mode":@"two click"}];
            if (self.info.transaction.orderID) {
                [additionalData addEntriesFromDictionary:@{@"order id":self.info.transaction.orderID}];
            }
            [[MIDUITrackingManager shared] trackEventName:@"pg cc card details" additionalParameters:additionalData];
            [self performTwoClicksWithCard:card];
        }
    }
}
- (void)totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.totalAmountBorderedView items:self.info.items];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MIDSavedCardInfo *card = self.savedCards[indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.title"]
                                                                       message:[VTClassHelper getTranslationFromAppBundleForString:@"alert.message-delete-card"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.no"] style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:[VTClassHelper getTranslationFromAppBundleForString:@"alert.yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteSavedCard:card];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)deleteSavedCard:(MIDSavedCardInfo *)card {
    [self showLoadingWithText:nil];
    [MIDCreditCardCharge deleteSavedCard:card.maskedCard
                               snapToken:self.snapToken
                              completion:^(id  _Nullable result, NSError * _Nullable error)
     {
         [self reloadCards:^{
             [self hideLoading];
         }];
     }];
}

- (void)reloadCards:(void (^)(void))completion {
    [MIDClient getPaymentInfoWithToken:self.snapToken completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error) {
        [MIDVendorUI shared].info = info;
        [self.tableView reloadData];
        
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - MidtransNewCreditCardViewControllerDelegate

- (void)didDeleteSavedCard {
    [self.navigationController popToViewController:self animated:YES];
    
    [self reloadCards:nil];
}

@end
