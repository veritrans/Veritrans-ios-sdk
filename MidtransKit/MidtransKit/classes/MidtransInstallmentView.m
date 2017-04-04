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
#import "MidtransUIThemeManager.h"

@interface MidtransInstallmentView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic) NSInteger installmentCurrentIndex;
@end;
@implementation MidtransInstallmentView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *image = [UIImage imageNamed:@"icon_btn_min_" inBundle:VTBundle compatibleWithTraitCollection:nil];
    [self.prevButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    image = [UIImage imageNamed:@"icon_btn_plus_" inBundle:VTBundle compatibleWithTraitCollection:nil];
    [self.nextButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    self.prevButton.tintColor = [[MidtransUIThemeManager shared] themeColor];
    self.nextButton.tintColor = [[MidtransUIThemeManager shared] themeColor];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MidtransInstallmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"installmentCell" forIndexPath:indexPath];
    if (self.installmentData.count){
          [cell configureInstallmentWithText:[NSString stringWithFormat:@"%@",self.installmentData[indexPath.row]]];
    }
    else{
      [cell configurePointWithThext:(NSNumber *)self.pointData[indexPath.row]];
    }
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.installmentData.count){
        return self.installmentData.count;
    }
    else {
        return self.pointData.count;
    }
    
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
    self.installmentCollectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.97 blue:0.99 alpha:1.0];
    self.installmentCollectionView.pagingEnabled = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (UICollectionViewCell *cell in [self.installmentCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.installmentCollectionView indexPathForCell:cell];
        self.installmentCurrentIndex = indexPath.row;
    }
}
- (void)configurePointView:(NSArray *)pointData {
    self.pointData = pointData;
    self.installmentCurrentIndex = self.pointData.count;
    [self.installmentCollectionView reloadData];
}
- (void)configureInstallmentView:(NSArray *)installmentContent {
    self.installmentData = installmentContent;
    [self.installmentCollectionView reloadData];
}
- (IBAction)prevButtonDidtapped:(id)sender {
    if (self.installmentCurrentIndex > 0) {
        self.installmentCurrentIndex --;
        self.nextButton.enabled = YES;
        [self selectedIndex:self.installmentCurrentIndex];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.installmentCurrentIndex inSection:0];
        [self.installmentCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else {
       self.prevButton.enabled = NO;
    }
}
- (IBAction)nextButtonDidTapped:(id)sender {
    if (self.installmentCurrentIndex < self.installmentData.count - 1) {
        self.installmentCurrentIndex ++;
            self.prevButton.enabled = YES;
        [self selectedIndex:self.installmentCurrentIndex];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.installmentCurrentIndex inSection:0];
        [self.installmentCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else {
     self.nextButton.enabled = NO;
    }
}
- (void)resetInstallmentIndex {
    if (self.pointData) {
        self.installmentCurrentIndex = self.pointData.count;
    }
    else{
        self.installmentCurrentIndex  = 0;
    }
    self.prevButton.enabled = NO;
    self.nextButton.enabled = YES;
    [self selectedIndex:0];
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
