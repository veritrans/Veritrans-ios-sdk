//
//  MidtransInstallmentView.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/11/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MidtransInstallmentViewDelegate <NSObject>
- (void)installmentSelectedIndex:(NSInteger)index;
@end
@interface MidtransInstallmentView : UIView
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (nonatomic,strong) NSArray *installmentData;
@property (nonatomic,strong) NSArray *pointData;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) id<MidtransInstallmentViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *installmentCollectionView;
- (void)setupInstallmentCollection;
- (void)resetInstallmentIndex;
- (void)configureInstallmentView:(NSArray *)installmentContent;
- (void)configurePointView:(NSArray *)pointData;
@end
