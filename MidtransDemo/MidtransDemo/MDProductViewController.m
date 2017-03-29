//
//  MDProductDetailViewController.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/24/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDProductViewController.h"
#import "MDImageCollectionViewCell.h"
#import "MDOrderViewController.h"
#import "MDUtils.h"

@interface MDProductViewController () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) NSArray *images;
@end

@implementation MDProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Product Detail";
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsPressed:)];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MDImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MDImageCollectionViewCell"];
    
    self.images = @[[UIImage imageNamed:@"slide_img_1"], [UIImage imageNamed:@"slide_img_2"], [UIImage imageNamed:@"slide_img_2"]];
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor mdThemeColor];
    defaults_observe_object(@"md_color", ^(NSNotification *note){
        self.pageControl.currentPageIndicatorTintColor = [UIColor mdThemeColor];
    });
}

- (void)settingsPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)beliPressed:(id)sender {
    MDOrderViewController *vc = [[MDOrderViewController alloc] initWithNibName:@"MDOrderViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.pageControl.currentPage = self.collectionView.contentOffset.x / pageWidth;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MDImageCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = self.images[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

@end
