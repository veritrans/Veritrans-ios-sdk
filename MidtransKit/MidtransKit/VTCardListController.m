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
#import "VTTextField.h"
#import "VTCCBackView.h"
#import "VTCCFrontView.h"
#import "VTHudView.h"
#import "VTPaymentStatusViewModel.h"
#import "VTCardControllerConfig.h"

#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "VTConfirmPaymentController.h"
#import "UIViewController+Modal.h"

#import <MidtransCoreKit/VTClient.h>
#import <MidtransCoreKit/VTMerchantClient.h>
#import <MidtransCoreKit/VTPaymentCreditCard.h>
#import <MidtransCoreKit/VTTransactionDetails.h>

//#import <CardIO.h>

@interface VTCardListController () <VTCardCellDelegate, VTAddCardControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate/*, CardIOPaymentViewControllerDelegate*/>
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
    VTHudView *_hudView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = UILocalizedString(@"creditcard.list.title", nil);
    
    _hudView = [[VTHudView alloc] init];
    
    [_pageControl setNumberOfPages:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardsUpdated:) name:VTMaskedCardsUpdated object:nil];
    
    _amountLabel.text = self.transactionDetails.grossAmount.formattedCurrencyNumber;
    
    [self updateView];
    
    [self reloadMaskedCards];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"VTCardCell" bundle:VTBundle] forCellWithReuseIdentifier:@"VTCardCell"];
    //cell editing
    [_collectionView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startEditing:)]];
    self.editingCell = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditingCell:(BOOL)editingCell {
    _editingCell = editingCell;
    
    [_collectionView reloadData];
}

- (void)startEditing:(id)sender {
    self.editingCell = true;
}

- (void)reloadMaskedCards {
    [_hudView showOnView:self.view];
    
    __weak VTCardListController *wself = self;
    [[VTMerchantClient sharedClient] fetchMaskedCardsWithCompletion:^(NSArray *maskedCards, NSError *error) {
        [_hudView hide];
        
        if (maskedCards) {
            wself.cards = [NSMutableArray arrayWithArray:maskedCards];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [self updateView];
    }];
}


- (void)updateView {
    if (self.cards.count) {
        _addCardButton.hidden = true;
        _addCardButtonHeight.constant = 0;
        _emptyCardView.hidden = true;
        _cardsView.hidden = false;
    } else {
        _addCardButton.hidden = false;
        _addCardButtonHeight.constant = 50.;
        _emptyCardView.hidden = false;
        _cardsView.hidden = true;
    }
}

- (void)cardsUpdated:(id)sender {
    [self reloadMaskedCards];
}

- (void)setCards:(NSMutableArray *)cards {
    _cards = cards;
    
    [_pageControl setNumberOfPages:[cards count]];
    [_collectionView reloadData];
}

- (IBAction)addCardPressed:(id)sender {
    VTAddCardController *vc = [[VTAddCardController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails paymentMethodName:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return [PushAnimator new];;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_cards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VTCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VTCardCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.maskedCard = _cards[indexPath.row];
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
    
    VTMaskedCreditCard *maskedCard = _cards[indexPath.row];
    
    if ([[VTCardControllerConfig sharedInstance] enableOneClick]) {
        VTConfirmPaymentController *vc = [[VTConfirmPaymentController alloc] initWithCardNumber:maskedCard.maskedNumber grossAmount:self.transactionDetails.grossAmount];
        [vc showOnViewController:self.navigationController clickedButtonsCompletion:^(NSUInteger selectedIndex) {
            if (selectedIndex == 1) {
                [self payWithToken:maskedCard.savedTokenId];
            }
        }];
    } else {
        VTTwoClickController *vc = [[VTTwoClickController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails maskedCard:maskedCard];
        [self.navigationController setDelegate:self];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Helper

- (void)payWithToken:(NSString *)token {
    [_hudView showOnView:self.navigationController.view];
    
    VTPaymentCreditCard *paymentDetail =
    [[VTPaymentCreditCard alloc] initWithFeature:VTCreditCardPaymentFeatureOneClick
                                           token:token];
    VTTransaction *transaction =
    [[VTTransaction alloc] initWithPaymentDetails:paymentDetail
                               transactionDetails:self.transactionDetails
                                  customerDetails:self.customerDetails
                                      itemDetails:self.itemDetails];
    [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
        [_hudView hide];
        
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

#pragma mark - VTAddCardControllerDelegate

- (void)viewController:(VTAddCardController *)viewController didRegisterCard:(VTMaskedCreditCard *)registeredCard {
    [self.navigationController popViewControllerAnimated:YES];
    [self reloadMaskedCards];
}

#pragma mark - VTCardCellDelegate

- (void)cardCellShouldRemoveCell:(VTCardCell *)cell {
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    VTMaskedCreditCard *card = _cards[indexPath.row];
    [[VTMerchantClient sharedClient] deleteMaskedCard:card completion:^(BOOL success, NSError *error) {
        if (success) {
            [_cards removeObjectAtIndex:indexPath.row];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [_pageControl setNumberOfPages:[_cards count]];
            
            self.editingCell = false;
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [self updateView];
    }];
}

#pragma MARK - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 200);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
 - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
 if (buttonIndex == 0) {
 VTAddCardController *vc = [[VTAddCardController alloc] initWithCustomerDetails:self.customerDetails itemDetails:self.itemDetails transactionDetails:self.transactionDetails];
 vc.delegate = self;
 [self.navigationController pushViewController:vc animated:YES];
 } else if (buttonIndex == 1) {
 CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
 [self presentViewController:scanViewController animated:YES completion:nil];
 }
 }
 */

/*
 #pragma mark - CardIOPaymentViewControllerDelegate
 
 /// This method will be called if the user cancels the scan. You MUST dismiss paymentViewController.
 /// @param paymentViewController The active CardIOPaymentViewController.
 - (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
 [self dismissViewControllerAnimated:YES completion:nil];
 }
 
 /// This method will be called when there is a successful scan (or manual entry). You MUST dismiss paymentViewController.
 /// @param cardInfo The results of the scan.
 /// @param paymentViewController The active CardIOPaymentViewController.
 - (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
 
 NSString *year = cardInfo.expiryYear < 10 ? [NSString stringWithFormat:@"0%lu", (unsigned long)cardInfo.expiryYear] : [NSString stringWithFormat:@"%lu", (unsigned long)cardInfo.expiryYear];
 NSString *month = cardInfo.expiryMonth < 10 ? [NSString stringWithFormat:@"0%lu", (unsigned long)cardInfo.expiryMonth] : [NSString stringWithFormat:@"%lu", (unsigned long)cardInfo.expiryMonth];
 
 VTCreditCard *creditCard = [[VTCreditCard alloc] initWithNumber:cardInfo.cardNumber
 expiryMonth:month
 expiryYear:year
 cvv:cardInfo.cvv];
 
 [[VTClient sharedClient] registerCreditCard:creditCard completion:^(VTMaskedCreditCard *maskedCreditCard, NSError *error) {
 [_hudView hide];
 
 if (error) {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
 [alert show];
 } else {
 [[VTMerchantClient sharedClient] saveRegisteredCard:maskedCreditCard completion:^(id result, NSError *error) {
 if (error) {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
 [alert show];
 } else {
 [self reloadMaskedCards];
 [self dismissViewControllerAnimated:YES completion:nil];
 }
 }];
 }
 }];
 }
 */
@end
