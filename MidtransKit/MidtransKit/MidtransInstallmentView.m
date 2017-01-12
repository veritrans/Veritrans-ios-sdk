//
//  MidtransInstallmentView.m
//  MidtransKit
//
//  Created by Vanbungkring on 1/11/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransInstallmentView.h"
#import "VTClassHelper.h"
#import "MidtransCollectionViewLayout.h"
#import "MidtransInstallmentCollectionViewCell.h"
@interface MidtransInstallmentView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic) NSInteger installmentCurrentIndex;
@end;
@implementation MidtransInstallmentView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MidtransInstallmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"installmentCell" forIndexPath:indexPath];
    [cell configureInstallmentWithText:[NSString stringWithFormat:@"%@",self.installmentData[indexPath.row]]];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.installmentData.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView  layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
    
}

- (void)setupInstallmentCollection {
    self.installmentCurrentIndex = 0;
    self.prevButton.enabled = NO;
    self.installmentCollectionView.delegate = self;
    self.installmentCollectionView.dataSource = self;
    self.installmentCollectionView.collectionViewLayout = [[MidtransCollectionViewLayout alloc] initWithColumn:1 andHeight:50];
    [self.installmentCollectionView registerNib:[UINib nibWithNibName:@"MidtransInstallmentCollectionViewCell" bundle:VTBundle]
                     forCellWithReuseIdentifier:@"installmentCell"];
    self.installmentCollectionView.pagingEnabled = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (UICollectionViewCell *cell in [self.installmentCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.installmentCollectionView indexPathForCell:cell];
        self.installmentCurrentIndex = indexPath.row;
    }
}

- (void)configureInstallmentView:(NSArray *)installmentContent {
    self.installmentData = installmentContent;
    [self.installmentCollectionView reloadData];
}
- (IBAction)prevButtonDidtapped:(id)sender {
    if (self.installmentCurrentIndex >0) {
        self.installmentCurrentIndex --;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.installmentCurrentIndex inSection:0];
        [self.installmentCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else {
        self.prevButton.enabled = NO;
        self.nextButton.enabled = YES;
    }
}
- (IBAction)nextButtonDidTapped:(id)sender {
    if (self.installmentCurrentIndex <self.installmentData.count-1) {
        self.installmentCurrentIndex ++;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.installmentCurrentIndex inSection:0];
        [self.installmentCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else {
        self.prevButton.enabled = YES;
        self.nextButton.enabled = NO;
    }
}
- (void)resetInstallmentIndex {
    self.installmentCurrentIndex  = 0;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.installmentCurrentIndex inSection:0];
    [self.installmentCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.installmentCollectionView reloadData];
}
- (void)selectedIndex:(NSInteger)indexSelected {
    if ([self.delegate respondsToSelector:@selector(installmentSelectedIndex:)]) {
        [self.delegate installmentSelectedIndex:indexSelected];
    }
}
@end
