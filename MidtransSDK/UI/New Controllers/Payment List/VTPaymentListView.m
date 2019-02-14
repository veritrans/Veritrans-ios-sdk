//
//  VTPaymentListView.m
//  MidtransKit
//
//  Created by Arie on 6/17/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentListView.h"
#import "MidtransUIListCell.h"
#import "MidtransItemCell.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransTransactionDetailViewController.h"
#import "MIDArrayHelper.h"

@interface VTPaymentListView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) BOOL shouldExpand;

@property (nonatomic) NSArray <MidtransPaymentListModel *> *models;
@property (nonatomic) MIDPaymentInfo *info;
@end

@implementation VTPaymentListView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shouldExpand = NO;
    
    self.headerView = [[VTBundle loadNibNamed:@"MidtransPaymentMethodHeader" owner:self options:nil] lastObject];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransUIListCell" bundle:VTBundle] forCellReuseIdentifier:@"MidtransUIListCell"];
}

-(void)drawRect:(CGRect)rect {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 1);
    CGContextMoveToPoint(currentContext,CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(currentContext,CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextStrokePath(currentContext);
}

- (NSArray *)loadPaymentMethodDetails {
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", @"paymentMethods"];
    NSString *path = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (path == nil) {
        path = [VTBundle pathForResource:@"en_paymentMethods" ofType:@"plist"];
    }
    return [NSArray arrayWithContentsOfFile:path];
}

- (void)setPaymentInfo:(MIDPaymentInfo *)info {
    self.info = info;
    
    self.headerView.priceAmountLabel.text = [info.items formattedGrossAmount];
    
    NSArray *details = [self loadPaymentMethodDetails];
    
    NSArray *payments = [info.enabledPayments filter:^BOOL(MIDPaymentMethodInfo *obj) {
        return obj.category != MIDPaymentCategoryBankTransfer;
    }];
    
    //map to payment list model
    NSMutableArray *models = [NSMutableArray new];
    [payments enumerateObjectsUsingBlock:^(MIDPaymentMethodInfo * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [details indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj[@"id"] isEqualToString:[NSString stringFromPaymentMethod:info.type]];
        }];
        if (index != NSNotFound) {
            [models addObject:[[MidtransPaymentListModel alloc] initWithDictionary:details[index]]];
        }
    }];
    
    //create VA group model
    NSString *_desc = [VTClassHelper getTranslationFromAppBundleForString:@"Pay from ATM Bersama, Prima or Alto"];
    NSDictionary *_dict = @{@"description":_desc,
                            @"id":@"va",
                            @"identifier":@"va",
                            @"shortName":@"atm transfer",
                            @"title":@"ATM/Bank Transfer"
                            };
    [models insertObject:[[MidtransPaymentListModel alloc] initWithDictionary:_dict] atIndex:1];
    
    self.models = models;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransUIListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MidtransUIListCell"];
    if (!cell) {
        cell = [[MidtransUIListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MidtransUIListCell"];
    }
    [cell configureWithModel:self.models[indexPath.row] info:self.info];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        MidtransPaymentListModel *paymentModel = self.models[indexPath.row];
    if ([paymentModel.status isEqualToString:@"down"]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(paymentListView:didSelectAtIndex:)]) {
        [self.delegate paymentListView:self didSelectAtIndex:indexPath.row];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     MidtransPaymentListModel *paymentModel = self.models[indexPath.row];
    if ([paymentModel.status isEqualToString:@"down"]) {
        return 120;
    }
   return 80;
}

@end
