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

@interface MidtransSavedCardController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) MidtransPaymentRequestV2CreditCard *creditCard;
@property (nonatomic) NSMutableArray *cards;
@property (nonatomic) MidtransPaymentMethodHeader *headerView;
@property (nonatomic) MidtransSavedCardFooter *footerView;
@end

@implementation MidtransSavedCardController

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
            andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard {
    self = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:VTBundle];
    if (self) {
        self.token = token;
        self.paymentMethod = paymentMethod;
        self.creditCard = creditCard;
    }
    return self;
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
                                                                                       andCreditCardData:self.creditCard];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransNewCreditCardViewController *vc = [[MidtransNewCreditCardViewController alloc] initWithToken:self.token
                                                                                              maskedCard:self.cards[indexPath.row]
                                                                                              creditCard:self.creditCard];
    [self.navigationController pushViewController:vc animated:YES];
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
    return 40;
}

@end
