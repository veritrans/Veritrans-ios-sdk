//
//  VTCardListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCardListController.h"
#import <MidtransCoreKit/VTItem.h>
#import <MidtransCoreKit/VTConfig.h>

#import "PushAnimator.h"

#import "VTClassHelper.h"
#import "VTAddCardController.h"
#import "VTTwoClickController.h"
#import "VTTextField.h"
#import "VTCCBackView.h"
#import "VTCCFrontView.h"
#import "VTHudView.h"
#import "VTPaymentStatusViewModel.h"

#import "VTSuccessStatusController.h"
#import "VTErrorStatusController.h"
#import "VTConfirmPaymentController.h"
#import "UIViewController+Modal.h"
#import "UICollectionView+Empty.h"

#import <MidtransCoreKit/VTClient.h>
#import <MidtransCoreKit/VTMerchantClient.h>
#import <MidtransCoreKit/VTPaymentCreditCard.h>
#import <MidtransCoreKit/VTCTransactionDetails.h>

@interface VTCardListController () <VTCardCellDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *paymentView;
@property (strong, nonatomic) IBOutlet UIView *emptyCardView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic, readwrite) VTCustomerDetails *customer;
@property (nonatomic, readwrite) NSArray *items;
@property (nonatomic) NSMutableArray *cards;

@property (nonatomic) BOOL editingCell;
@end

@implementation VTCardListController {
    VTHudView *_hudView;
    NSNumber *_grossAmount;
}

+ (instancetype)controllerWithCustomer:(VTCustomerDetails *)customer items:(NSArray *)items {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Midtrans" bundle:VTBundle];
    VTCardListController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VTCardListController"];
    vc.customer = customer;
    vc.items = items;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _hudView = [[VTHudView alloc] init];
    
    _collectionView.emptyDataView = _emptyCardView;
    
    [_pageControl setNumberOfPages:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardsUpdated:) name:VTMaskedCardsUpdated object:nil];
    
    _grossAmount = [_items itemsPriceAmount];
    
    NSNumberFormatter *formatter = [NSObject numberFormatterWith:@"vt.number"];
    _amountLabel.text = [formatter stringFromNumber:_grossAmount];
    
    [self reloadMaskedCards];
    
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
    }];
}

- (void)cardsUpdated:(id)sender {
    [self reloadMaskedCards];
}

- (void)setCards:(NSMutableArray *)cards {
    _cards = cards;
    
    [_pageControl setNumberOfPages:[cards count]];
    [_collectionView reloadData];
}

- (IBAction)newCardPressed:(UITapGestureRecognizer *)sender {
    VTAddCardController *vc = [VTAddCardController controllerWithCustomer:_customer items:_items];
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
    
    if ([CONFIG creditCardFeature] == VTCreditCardFeatureOneClick) {
        
        VTConfirmPaymentController *vc =
        [VTConfirmPaymentController controllerWithMaskedCardNumber:maskedCard.maskedNumber
                                                       grossAmount:_grossAmount
                                                          callback:^(NSInteger selectedIndex)
         {
             [self dismissCustomViewController:nil];
             
             if (selectedIndex == 1) {
                 [_hudView showOnView:self.view];
                 
                 VTPaymentCreditCard *payDetail = [VTPaymentCreditCard paymentForTokenId:maskedCard.savedTokenId];
                 VTCTransactionDetails *transDetail = [[VTCTransactionDetails alloc] initWithGrossAmount:_grossAmount];
                 VTCTransactionData *transData = [[VTCTransactionData alloc] initWithpaymentDetails:payDetail
                                                                                 transactionDetails:transDetail
                                                                                    customerDetails:_customer
                                                                                        itemDetails:_items];
                 
                 [[VTMerchantClient sharedClient] performCreditCardTransaction:transData completion:^(VTPaymentResult *result, NSError *error) {
                     [_hudView hide];
                     
                     if (result) {
                         VTPaymentStatusViewModel *vm = [VTPaymentStatusViewModel viewModelWithPaymentResult:result];
                         VTSuccessStatusController *vc = [VTSuccessStatusController controllerWithSuccessViewModel:vm];
                         [self.navigationController pushViewController:vc animated:YES];
                     } else {
                         VTErrorStatusController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTErrorStatusController"];
                         [self.navigationController pushViewController:vc animated:YES];
                     }
                 }];
             }
         }];
        vc.modalSize = vc.preferredContentSize;
        [self presentCustomViewController:vc
                 presentingViewController:self.navigationController
                               completion:nil];
        
    } else {
        
        VTTwoClickController *vc = [VTTwoClickController controllerWithCustomer:_customer items:_items savedTokenId:maskedCard.savedTokenId];
        [self.navigationController setDelegate:self];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
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
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
            [alert show];
        }
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

@end
