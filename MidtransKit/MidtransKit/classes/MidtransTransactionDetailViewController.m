//
//  MidtransTransactionDetailViewController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 12/28/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransTransactionDetailViewController.h"
#import "VTClassHelper.h"
#import "MidtransItemCell.h"
#import "AddOnConstructor.h"
#import "MidtransUIThemeManager.h"

@interface MidtransTransactionDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) IBOutlet UILabel *priceAmountLabel;
@property (nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic) IBOutlet UIView *headerView;
@property (nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@end

@implementation MidtransTransactionDetailViewController

- (instancetype)init {
    self = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SNPUITrackingManager shared] trackEventName:@"pg order summary"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransItemCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransItemCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)]];
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)]];
    
}

- (void)backgroundTapped:(id)sender {
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        UIViewController *rootVC = [VTClassHelper rootViewController];
        [rootVC removeSubViewController:self];
    }];
}

- (void)presentAtPositionOfView:(UIView *)view items:(NSArray *)items WithPromoSelected:(AddOnConstructor *)MidtransPromo {
    UIViewController *rootVC = [VTClassHelper rootViewController];
    if (rootVC.navigationController) {
        rootVC = rootVC.navigationController;
    }
    self.view.alpha = 0.0;
    [rootVC addSubViewController:self toView:rootVC.view];
    
    CGRect generalRect = [rootVC.view convertRect:view.frame fromView:view.superview];
    //    self.topSpaceConstraint.constant = CGRectGetMinY(generalRect);
    self.bottomSpaceConstraint.constant = CGRectGetHeight(generalRect);
    MidtransItemDetail *itemDetails = items [0];
    NSInteger grossAmount =[itemDetails.price integerValue] - [MidtransPromo.addOnDescriptions integerValue];
    NSMutableArray *mockItems = [NSMutableArray arrayWithArray:items];
    self.priceAmountLabel.text = [NSString stringWithFormat:@"%ld",(long)grossAmount];
    
    MidtransItemDetail *itemDetailsMain =[[MidtransItemDetail alloc] initWithItemID:@"001"
                                                                               name:MidtransPromo.addOnTitle
                                                                              price:[NSNumber numberWithInteger:-[MidtransPromo.addOnDescriptions integerValue]] quantity:@1];
    
    [mockItems addObject:itemDetailsMain];
    
    self.items = mockItems;
    self.tableHeightConstraint.constant = [self calculateTableViewHeight];
    
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
    
}
- (void)presentAtPositionOfView:(UIView *)view items:(NSArray *)items
         withChangedGrossAmount:(NSString *)grossAmount
                      pointName:(NSString *)pointName pointValue:(NSInteger)pointValue {
    UIViewController *rootVC = [VTClassHelper rootViewController];
    if (rootVC.navigationController) {
        rootVC = rootVC.navigationController;
    }
    
    self.view.alpha = 0.0;
    [rootVC addSubViewController:self toView:rootVC.view];
    
    CGRect generalRect = [rootVC.view convertRect:view.frame fromView:view.superview];
    //    self.topSpaceConstraint.constant = CGRectGetMinY(generalRect);
    self.bottomSpaceConstraint.constant = CGRectGetHeight(generalRect);
   
    NSMutableArray *mockItems = [NSMutableArray arrayWithArray:items];
    if (pointValue>0) {
         MidtransItemDetail *itemDetails =[[MidtransItemDetail alloc] initWithItemID:@"001" name:pointName price:[NSNumber numberWithInteger:-pointValue] quantity:@1];
        [mockItems addObject:itemDetails];
    }
    self.items = [NSArray arrayWithArray:mockItems];
    self.priceAmountLabel.text = grossAmount;
    self.tableHeightConstraint.constant = [self calculateTableViewHeight];
    
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}
- (void)presentAtPositionOfView:(UIView *)view items:(NSArray *)items {
    UIViewController *rootVC = [VTClassHelper rootViewController];
    if (rootVC.navigationController) {
        rootVC = rootVC.navigationController;
    }
    
    self.view.alpha = 0.0;
    [rootVC addSubViewController:self toView:rootVC.view];
    
    CGRect generalRect = [rootVC.view convertRect:view.frame fromView:view.superview];
//    self.topSpaceConstraint.constant = CGRectGetMinY(generalRect);
    self.bottomSpaceConstraint.constant = CGRectGetHeight(generalRect);
    
    self.items = items;
    self.priceAmountLabel.text = [items formattedPriceAmount];
    self.tableHeightConstraint.constant = [self calculateTableViewHeight];
    
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MidtransItemCell"];
    cell.itemDetail = self.items[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)calculateTableViewHeight {
    CGFloat result = 0;
    for (int i=0; i < self.items.count; i++) {
        static MidtransItemCell *cell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"MidtransItemCell"];
        });
        cell.itemDetail = self.items[i];
        result += [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static MidtransItemCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"MidtransItemCell"];
    });
    cell.itemDetail = self.items[indexPath.row];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
