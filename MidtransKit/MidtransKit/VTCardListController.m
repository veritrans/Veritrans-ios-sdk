//
//  VTCardListController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCardListController.h"
#import <MidtransCoreKit/VTItem.h>
#import "VTClassHelper.h"
#import "VTAddCardController.h"
#import "VTInputCvvController.h"
#import "VTTextField.h"

@interface VTCardListController () <VTCardCellDelegate>
@property (nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *inputCvvView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *paymentView;
@property (strong, nonatomic) IBOutlet VTTextField *cvvTextField;
@end

@implementation VTCardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cards = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
    [_pageControl setNumberOfPages:[_cards count]];
    
    _cvvTextField.inputAccessoryView = _paymentView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newCardPressed:(UITapGestureRecognizer *)sender {
    VTAddCardController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTAddCardController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_cards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VTCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VTCardCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.creditCard = nil;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

#pragma mark - VTCardCellDelegate

- (void)cardCellShouldRemoveCell:(VTCardCell *)cell {
    
}

- (void)cardCell:(VTCardCell *)cell willChangePage:(CardPageState)pageState duration:(NSTimeInterval)duration {
    if (pageState == CardPageStateFront) {
        [self.view endEditing:YES];
        [UIView animateWithDuration:duration animations:^{
            _inputCvvView.alpha = 0;
            _infoView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            _inputCvvView.alpha = 1.0;
            _infoView.alpha = 0;
        }];
    }
}

- (void)cardCell:(VTCardCell *)cell didChangePage:(CardPageState)pageState duration:(NSTimeInterval)duration {
    if (pageState == CardPageStateBack) {
        [_cvvTextField becomeFirstResponder];
        [_collectionView setScrollEnabled:NO];
    } else {
        [_collectionView setScrollEnabled:YES];
    }
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
