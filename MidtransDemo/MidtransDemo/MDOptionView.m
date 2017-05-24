//
//  MDOptionView.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionView.h"
#import "MDOptionCell.h"
#import "MDOptionColorCell.h"
#import "MDOptionComposerCell.h"
#import "MDUtils.h"
#import "MDOptionManager.h"

@interface MDOptionView()<UITableViewDelegate, UITableViewDataSource, MDOptionComposerCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowView;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic) UIImage *icon;
@property (nonatomic) NSString *titleTemplate;
@end

@implementation MDOptionView

static CGFloat const optionCellHeight = 40;

+ (MDOptionView *)viewWithIcon:(UIImage *)icon titleTemplate:(NSString *)titleTemplate options:(NSArray<MDOption *> *)options identifier:(NSString *)identifier {
    
    MDOptionView *view = [[NSBundle mainBundle] loadNibNamed:@"MDOptionView" owner:self options:nil].firstObject;
    view.icon = icon;
    view.titleTemplate = titleTemplate;
    view.options = options;
    view.identifier = identifier;
    
    [view commonInit];
    
    return view;
}
- (void)resetOptionView {
    [self.tableView reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MDOptionCell" bundle:nil] forCellReuseIdentifier:@"MDOptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MDOptionColorCell" bundle:nil] forCellReuseIdentifier:@"MDOptionColorCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MDOptionComposerCell" bundle:nil] forCellReuseIdentifier:@"MDOptionComposerCell"];
    [self.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titlePressed:)]];
    
    self.selected = NO;
    
    defaults_observe_object(@"md_color", ^(NSNotification *note){
        self.selected = self.selected;
    });
}

- (void)selectOptionAtIndex:(NSInteger)index {
    [self updateViewIndexOption:index thenSelectTable:YES];
}

- (void)updateViewIndexOption:(NSUInteger)index thenSelectTable:(BOOL)thenSelectTable {
    index = index == NSNotFound? 0:index;
    
    MDOption *option = [self.options objectAtIndex:index];
    self.titleLabel.text = [NSString stringWithFormat:self.titleTemplate, option.name];
    
    if (thenSelectTable) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)commonInit {
    self.iconView.image = self.icon;
    
    [self.tableView reloadData];
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.iconView.tintColor = [UIColor mdThemeColor];
        self.titleLabel.textColor = [UIColor mdThemeColor];
        self.tableViewHeight.constant = optionCellHeight*self.options.count+2; //2 is two borders height
        self.arrowView.transform = CGAffineTransformMakeRotation(180 * M_PI/180.);
    }
    else {
        self.iconView.tintColor = [UIColor mdDarkColor];
        self.titleLabel.textColor = [UIColor mdDarkColor];
        self.tableViewHeight.constant = 0;
        self.arrowView.transform = CGAffineTransformIdentity;
    }
    _selected = selected;
}

- (void)titlePressed:(UIGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(optionView:didTapHeader:)]) {
        [self.delegate optionView:self didTapHeader:sender];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDOption *option = self.options[indexPath.row];
    UITableViewCell *resultCell;
    switch (option.type) {
        case MDOptionTypeComposer: {
            MDOptionComposerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDOptionComposerCell"];
            cell.option = option;
            cell.delegate = self;
            resultCell = cell;
            break;
        }
        case MDOptionTypeColor: {
            MDOptionColorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDOptionColorCell"];
            cell.titleLabel.text = option.name;
            cell.colorImageView.backgroundColor = option.value;
            resultCell = cell;
            break;
        }
        case MDOptionTypeGeneral: {
            MDOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDOptionCell"];
            cell.titleLabel.text = option.name;
            resultCell = cell;
            break;
        }
    }
    return resultCell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MDOption *option = self.options[indexPath.row];
    
    if ([cell isKindOfClass:[MDOptionComposerCell class]]) {
        if ([self.delegate respondsToSelector:@selector(optionView:didTapComposerOption:)]) {
            [self.delegate optionView:self didTapComposerOption:option];
        }
        return tableView.indexPathForSelectedRow;
    }
    else {
        return indexPath;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MDOption *option = self.options[indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[MDOptionComposerCell class]]) {
        ((MDOptionComposerCell *)cell).option = option;
    }
    
    [self updateViewIndexOption:indexPath.row thenSelectTable:NO];
    
    if ([self.delegate respondsToSelector:@selector(optionView:didTapOption:)]) {
        [self.delegate optionView:self didTapOption:option];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return optionCellHeight;
}

#pragma mark - MDOptionComposerCellDelegate

- (void)optionCell:(MDOptionComposerCell *)cell didEditOption:(MDOption *)option {
    if ([self.delegate respondsToSelector:@selector(optionView:didTapEditComposerOption:)]) {
        [self.delegate optionView:self didTapEditComposerOption:option];
    }
}

@end
