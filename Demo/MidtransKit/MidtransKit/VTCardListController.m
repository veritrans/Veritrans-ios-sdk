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
#import <MidtransCoreKit/MidtransClient.h>
#import <MidtransCoreKit/MidtransHelper.h>
#import <MidtransCoreKit/MidtransMerchantClient.h>
#import <MidtransCoreKit/MidtransPaymentCreditCard.h>
#import <MidtransCoreKit/MidtransTransactionDetails.h>

@interface VTCardListController () <MidtransUICardCellDelegate, VTAddCardControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *emptyCardView;
@property (strong, nonatomic) IBOutlet UIView *cardsView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UIButton *addCardButton;
@property (nonatomic) IBOutlet NSLayoutConstraint *addCardButtonHeight;

@property (nonatomic) NSMutableArray *cards;
@property (nonatomic) BOOL editingCell;
@end

@implementation VTCardListController {
    MidtransUIHudView *_hudView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cards = [NSMutableArray new];
    
    self.title = UILocalizedString(@"creditcard.list.title", nil);
    [self.pageControl setNumberOfPages:0];
    /**
     *  need to revisit
     *
     *  @param cardsUpdated: cardsUpdated: description
     *
     *  @return return value description
     */
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardsUpdated:) name:MidtransMaskedCardsUpdated object:nil];
    self.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    [self updateView];
    [self reloadMaskedCards];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MIdtransUICardCell" bundle:VTBundle] forCellWithReuseIdentifier:@"MIdtransUICardCell"];
    [self.collectionView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startEditing:)]];
    self.editingCell = false;
}

- (void)setEditingCell:(BOOL)editingCell {
    _editingCell = editingCell;
    [self.collectionView reloadData];
}

- (void)startEditing:(id)sender {
    self.editingCell = true;
}

- (void)reloadMaskedCards {
    [self showLoadingHud];
    [[MidtransMerchantClient sharedClient] fetchMaskedCardsCustomer:self.token.customerDetails
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


- (void)updateView {
    [self.pageControl setNumberOfPages:[self.cards count]];
    
    if (self.cards.count) {
        self.addCardButton.hidden = true;
        self.addCardButtonHeight.constant = 0;
        self.emptyCardView.hidden = true;
        self.cardsView.hidden = false;
    } else {
        self.addCardButton.hidden = false;
        self.addCardButtonHeight.constant = 50.;
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
    
    if ([CC_CONFIG paymentType] == VTCreditCardPaymentTypeOneclick) {
        VTConfirmPaymentController *vc =
        [[VTConfirmPaymentController alloc] initWithCardNumber:self.selectedMaskedCard.maskedNumber
                                                   grossAmount:self.token.transactionDetails.grossAmount];
        [vc showOnViewController:self.navigationController clickedButtonsCompletion:^(NSUInteger selectedIndex) {
            if (selectedIndex == 1) {
                [self payWithToken:self.selectedMaskedCard.savedTokenId];
            }
        }];
    }
    else {
        VTTwoClickController *vc = [[VTTwoClickController alloc] initWithToken:self.token
                                                                    maskedCard:self.selectedMaskedCard];
        [self.navigationController setDelegate:self];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    [_hudView showOnView:self.navigationController.view];
    
    MidtransPaymentCreditCard *paymentDetail = [[MidtransPaymentCreditCard alloc] initWithFeature:MidtransCreditCardPaymentFeatureOneClick
                                                                                  creditCardToken:token token:self.token];
    MidtransTransaction *transaction =
    [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail];
    [[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [_hudView hide];
        
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
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
    
    [[MidtransMerchantClient sharedClient] saveMaskedCards:self.cards
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
