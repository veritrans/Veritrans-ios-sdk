//
//  VTGuideView.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 8/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTGuideView.h"
#import "VTGuideCell.h"
#import "VTClassHelper.h"
#import "MidtransUIToast.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

static NSString *const cellIdentifier = @"VTGuideCell";

@interface VTGuideView() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *cachedCells;
@end

@implementation VTGuideView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.tableView = [UITableView new];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.tableView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|" options:0 metrics:0 views:@{@"table":self.tableView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:0 views:@{@"table":self.tableView}]];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 13)];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:VTBundle] forCellReuseIdentifier:cellIdentifier];
    
    self.cachedCells = [NSMutableDictionary new];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VTTapableLabelDidTapLink
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      
        [[UIPasteboard generalPasteboard] setString:note.object];
        [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self];
    }];
}

- (void)setInstructions:(NSArray<VTInstruction *> *)instructions {
    _instructions = instructions;
    
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instructions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setInstruction:self.instructions[indexPath.row] number:indexPath.row + 1];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        VTGuideCell *cachedCell = self.cachedCells[cellIdentifier];
        if (!cachedCell) {
            cachedCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
        [cachedCell setInstruction:self.instructions[indexPath.row] number:indexPath.row + 1];
        [cachedCell updateConstraintsIfNeeded];
        [cachedCell layoutIfNeeded];
        return [cachedCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        VTGuideCell *cachedCell = self.cachedCells[cellIdentifier];
        if (!cachedCell) {
            cachedCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
        [cachedCell setInstruction:self.instructions[indexPath.row] number:indexPath.row + 1];
        [cachedCell updateConstraintsIfNeeded];
        [cachedCell layoutIfNeeded];
        return [cachedCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
}

@end
