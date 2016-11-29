//
//  VTCardListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCardListController.h"

#import "PushAnimator.h"

#import "VTClassHelper.h"
#import "VTAddCardController.h"
#import "VTTwoClickController.h"
#import "MidtransUITextField.h"
#import "VTCCBackView.h"
#import "MidtransUICCFrontView.h"
#import "MidtransUIHudView.h"
#import "VTPaymentStatusViewModel.h"
#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "VTConfirmPaymentController.h"
#import "UIViewController+Modal.h"
#import "UIColor+MidtransColor.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

CGFloat const ButtonHeight = 56;

@interface VTCardListController () <MidtransUICardCellDelegate, VTAddCardControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *emptyCardView;
@property (strong, nonatomic) IBOutlet UIView *cardsView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UIButton *addCardButton;
@property (nonatomic) IBOutlet NSLayoutConstraint *addCardButtonHeight;
@property (nonatomic, strong) MidtransPaymentRequestV2CreditCard *creditCard;
@property (weak, nonatomic) IBOutlet UIButton *topAddCardButton;
@property (nonatomic) NSMutableArray *cards;
@property (nonatomic) BOOL editingCell;
@end

@implementation VTCardListController

-(instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
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
    NSLog(@"credit card data-->%@",self.creditCard);
    self.topAddCardButton.layer.borderColor = [UIColor MidtransAquaBlue].CGColor;
    self.topAddCardButton.layer.cornerRadius = 3.0f;
    self.topAddCardButton.layer.borderWidth = 1.1f;
    self.cards = [NSMutableArray new];
    self.title = UILocalizedString(@"creditcard.list.title", nil);
    [self.pageControl setNumberOfPages:0];
    self.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    
    [self updateView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MIdtransUICardCell" bundle:VTBundle] forCellWithReuseIdentifier:@"MIdtransUICardCell"];
    
    self.editingCell = false;
    
    if ([CC_CONFIG tokenStorageDisabled]) {
        [self.collectionView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startEditing:)]];
    }
    
    [self reloadMaskedCards];
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

- (void)setEditingCell:(BOOL)editingCell {
    _editingCell = editingCell;
    [self.collectionView reloadData];
}

- (void)startEditing:(id)sender {
    self.editingCell = true;
}

- (void)reloadMaskedCards {
    if ([CC_CONFIG tokenStorageDisabled]) {
        [self showLoadingHud];
        [[MidtransMerchantClient shared] fetchMaskedCardsCustomer:self.token.customerDetails
                                                       completion:^(NSArray * _Nullable maskedCards, NSError * _Nullable error)
         {
             [self hideLoadingHud];
             if (!maskedCards) {
                 [self showAlertViewWithTitle:@"Error"
                                   andMessage:error.localizedDescription
                               andButtonTitle:@"Close"];
                 return;
             } else {
                 [self.cards setArray:maskedCards];
                 [self.collectionView reloadData];
             }
             [self updateView];
         }];
    }
    else {
        NSArray *savedTokens = [self convertV2ModelCards:self.creditCard.savedTokens];
        self.cards.array = savedTokens;
        [self.collectionView reloadData];
        [self updateView];
    }
}


- (void)updateView {
    self.pageControl.numberOfPages = self.cards.count;
    if (self.cards.count) {
        self.addCardButton.hidden = true;
        self.addCardButtonHeight.constant = 0.0f;
        self.emptyCardView.hidden = true;
        self.cardsView.hidden = false;
    } else {
        self.addCardButton.hidden = false;
        self.addCardButtonHeight.constant = ButtonHeight;
        self.emptyCardView.hidden = false;
        self.cardsView.hidden = true;
    }
}

- (void)cardsUpdated:(id)sender {
    [self reloadMaskedCards];
}

- (void)setCards:(NSMutableArray *)cards {
    _cards = cards;
    
    [self.pageControl setNumberOfPages:[cards count]];
    [self.collectionView reloadData];
}

- (IBAction)addCardPressed:(id)sender {
    VTAddCardController *vc = [[VTAddCardController alloc] initWithToken:self.token maskedCards:self.cards];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [PushAnimator new];;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.cards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MIdtransUICardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MIdtransUICardCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.maskedCard = self.cards[indexPath.row];
    cell.editing = self.editingCell;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editingCell) {
        self.editingCell = false; return;
    }
    
    self.selectedMaskedCard = self.cards[indexPath.row];
    
    if ([CC_CONFIG tokenStorageDisabled]) {
        if ([CC_CONFIG paymentType] == MTCreditCardPaymentTypeOneclick) {
            [self performOneClick];
        }
        else {
            [self performTwoClicks];
        }
    }
    else {
        if ([self.selectedMaskedCard.tokenType isEqualToString:TokenTypeOneClick]) {
            [self performOneClick];
        }
        else {
            [self performTwoClicks];
        }
    }
}

- (void)performOneClick {
    VTConfirmPaymentController *vc =
    [[VTConfirmPaymentController alloc] initWithCardNumber:self.selectedMaskedCard.maskedNumber
                                               grossAmount:self.token.transactionDetails.grossAmount];
    [vc showOnViewController:self.navigationController clickedButtonsCompletion:^(NSUInteger selectedIndex) {
        if (selectedIndex == 1) {
            [self showLoadingHud];
            
            MidtransPaymentCreditCard *paymentDetail = [MidtransPaymentCreditCard paymentOneClickWithMaskedCard:self.selectedMaskedCard.maskedNumber customer:self.token.customerDetails];
            MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:self.token];
            
            [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
                [self hideLoadingHud];
                
                if (error) {
                    [self handleTransactionError:error];
                } else {
                    [self handleTransactionSuccess:result];
                }
            }];
        }
    }];
}

- (void)performTwoClicks {
    VTTwoClickController *vc = [[VTTwoClickController alloc] initWithToken:self.token
                                                                maskedCard:self.selectedMaskedCard];
    [self.navigationController setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - VTAddCardControllerDelegate

- (void)viewController:(VTAddCardController *)viewController didRegisterCard:(MidtransMaskedCreditCard *)registeredCard {
    [self.navigationController popViewControllerAnimated:YES];
    [self reloadMaskedCards];
}

#pragma mark - MIdtransUICardCellDelegate

- (void)cardCellShouldRemoveCell:(MIdtransUICardCell *)cell {
    [self showLoadingHud];
    
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    
    [[MidtransMerchantClient shared] saveMaskedCards:self.cards
                                            customer:self.token.customerDetails
                                          completion:^(id  _Nullable result, NSError * _Nullable error)
     {
         [self hideLoadingHud];
         
         if (!error) {
             [self.cards removeObjectAtIndex:indexPath.row];
             [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
             self.editingCell = false;
         } else {
             [self showAlertViewWithTitle:@"Error"
                               andMessage:error.localizedDescription
                           andButtonTitle:@"Close"];
         }
         
         [self updateView];
     }];
}

#pragma MARK - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 200);
}

@end
