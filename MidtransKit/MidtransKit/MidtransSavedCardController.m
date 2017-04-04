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
#import "VTConfirmPaymentController.h"

@interface MidtransSavedCardController () <UITableViewDelegate, UITableViewDataSource, MidtransNewCreditCardViewControllerDelegate>
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) MidtransPaymentRequestV2CreditCard *creditCard;
@property (nonatomic) NSMutableArray *cards;
@property (nonatomic) MidtransPaymentMethodHeader *headerView;
@property (nonatomic) MidtransSavedCardFooter *footerView;
@property (nonatomic) NSArray *bankBinList;
@property (nonatomic) MidtransPaymentRequestV2Response * responsePayment;
@end

@implementation MidtransSavedCardController
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
            andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard
 andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response *)responsePayment {
    self = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:VTBundle];
    if (self) {
        self.token = token;
        self.paymentMethod = paymentMethod;
        self.responsePayment = responsePayment;
        self.creditCard = creditCard;
        self.bankBinList = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:[VTBundle pathForResource:@"bin" ofType:@"json"]] options:kNilOptions error:nil];
    }
    return self;
}

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
    self.footerView = [[VTBundle loadNibNamed:@"MidtransSavedCardFooter" owner:self options:nil] lastObject];
    [self.footerView.addCardButton addTarget:self action:@selector(addCardPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headerView = [[VTBundle loadNibNamed:@"MidtransPaymentMethodHeader" owner:self options:nil] lastObject];
    self.headerView.priceAmountLabel.text = self.token.itemDetails.formattedPriceAmount;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransSavedCardCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransSavedCardCell"];
    
    self.cards = [NSMutableArray new];
    self.title = UILocalizedString(@"creditcard.list.title", nil);
    
    [self reloadSavedCards];
}

- (void)reloadSavedCards {
    if (CC_CONFIG.tokenStorageEnabled) {
        NSArray *savedTokens = [self convertV2ModelCards:self.creditCard.savedTokens];
        [self.cards setArray:savedTokens];
        [self.tableView reloadData];
    }
    else {
        [self showLoadingWithText:nil];
        [[MidtransMerchantClient shared] fetchMaskedCardsCustomer:self.token.customerDetails completion:^(NSArray * _Nullable maskedCards, NSError * _Nullable error) {
            [self hideLoading];
            if (!maskedCards) {
                [self showAlertViewWithTitle:@"Error"
                                  andMessage:error.localizedDescription
                              andButtonTitle:@"Close"];
                return;
            }
            else {
                [self.cards setArray:maskedCards];
                [self.tableView reloadData];
            }
        }];
    }
}

- (NSArray <MidtransMaskedCreditCard*>*)convertV2ModelCards:(NSArray <MidtransPaymentRequestV2SavedTokens*>*)cards {
    NSMutableArray *formattedCards = [NSMutableArray new];
    for (MidtransPaymentRequestV2SavedTokens *card in cards) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[kMTMaskedCreditCardCardhash] = card.maskedCard;
        dict[kMTMaskedCreditCardExpiresAt] = card.expiresAt;
        dict[kMTMaskedCreditCardTokenType] = card.tokenType;
        
        if ([card.tokenType isEqualToString:TokenTypeTwoClicks] && card.token) {
            dict[kMTMaskedCreditCardIdentifier] = card.token;
        }
        
        MidtransMaskedCreditCard *newCard = [[MidtransMaskedCreditCard alloc] initWithDictionary:dict];
        [formattedCards addObject:newCard];
    }
    return formattedCards;
}

- (void)addCardPressed:(id)sender {
    MidtransNewCreditCardViewController *vc = [[MidtransNewCreditCardViewController alloc] initWithToken:self.token
                                                                                       paymentMethodName:self.paymentMethod
                                                                                       andCreditCardData:self.creditCard
                                                                            andCompleteResponseOfPayment:self.responsePayment];
    vc.promos = self.promos;
    vc.currentMaskedCards = self.cards;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)performOneClickWithCard:(MidtransMaskedCreditCard *)card {
    VTConfirmPaymentController *vc =
    [[VTConfirmPaymentController alloc] initWithCardNumber:card.maskedNumber
                                               grossAmount:self.token.transactionDetails.grossAmount];
    [vc showOnViewController:self.navigationController clickedButtonsCompletion:^(NSUInteger selectedIndex) {
        if (selectedIndex == 1) {
            [self showLoadingWithText:@"Processing your transaction"];
            
            MidtransPaymentCreditCard *paymentDetail =
            [MidtransPaymentCreditCard modelWithMaskedCard:card.maskedNumber
                                                  customer:self.token.customerDetails
                                                  saveCard:NO
                                               installment:nil];
            MidtransTransaction *transaction =
            [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail
                                                          token:self.token];
            
            [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
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

- (void)performTwoClicksWithCard:(MidtransMaskedCreditCard *)card {
    MidtransNewCreditCardViewController *vc =
    [[MidtransNewCreditCardViewController alloc] initWithToken:self.token
                                                    maskedCard:card
                                                    creditCard:self.creditCard
                                  andCompleteResponseOfPayment:self.responsePayment];
    vc.promos = self.promos;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransSavedCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MidtransSavedCardCell"];
    MidtransMaskedCreditCard *card = self.cards[indexPath.row];
    cell.maskedCard = card;
    NSUInteger index = [self.promos indexOfObjectPassingTest:^BOOL(MidtransPromo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSString *bin in obj.bins) {
            return [card.maskedNumber containsString:bin];
        }
        return NO;
    }];
    cell.havePromo = index != NSNotFound;
    cell.bankName = [self bankNameFromNumber:card.maskedNumber];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransMaskedCreditCard *card = self.cards[indexPath.row];
    if (CC_CONFIG.tokenStorageEnabled) {
        if ([card.tokenType isEqualToString:TokenTypeOneClick]) {
            [self performOneClickWithCard:card];
        }
        else {
            [self performTwoClicksWithCard:card];
        }
    }
    else {
        if ([CC_CONFIG paymentType] == MTCreditCardPaymentTypeOneclick) {
            [self performOneClickWithCard:card];
        }
        else {
            [self performTwoClicksWithCard:card];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:UILocalizedString(@"alert.title", nil)
                                                        message:UILocalizedString(@"alert.message-delete-card", nil)
                                                       delegate:self
                                              cancelButtonTitle:UILocalizedString(@"alert.no", nil)
                                              otherButtonTitles:UILocalizedString(@"alert.yes", nil), nil];
        [alert setTag:indexPath.row];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self showLoadingWithText:nil];
        MidtransMaskedCreditCard *card = self.cards[alertView.tag];
        [[MidtransMerchantClient shared] deleteMaskedCreditCard:card token:self.token completion:^(BOOL success) {
            [self hideLoading];
            
            if (success == NO) {
                return;
            }
            
            NSMutableArray *savedTokensM = self.creditCard.savedTokens.mutableCopy;
            NSUInteger index = [savedTokensM indexOfObjectPassingTest:^BOOL(MidtransPaymentRequestV2SavedTokens *savedToken, NSUInteger idx, BOOL * _Nonnull stop) {
                return [card.savedTokenId isEqualToString:savedToken.token];
            }];
            if (index != NSNotFound) {
                [savedTokensM removeObjectAtIndex:index];
            }
            self.creditCard.savedTokens = savedTokensM;
            
            [self reloadSavedCards];
        }];
    }
}

#pragma mark - MidtransNewCreditCardViewControllerDelegate

- (void)didDeleteSavedCard {
    [self.navigationController popToViewController:self animated:YES];
    [self reloadSavedCards];
}

@end
