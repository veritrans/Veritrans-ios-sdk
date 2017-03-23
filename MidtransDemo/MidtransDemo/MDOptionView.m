//
//  MDOptionView.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/23/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOptionView.h"
#import "MDOptionCell.h"
#import "MDUtils.h"

@interface MDOptionView()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowView;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic) UIImage *icon;
@property (nonatomic) NSArray <NSString*>*options;
@property (nonatomic) NSString *titleTemplate;
@end

@implementation MDOptionView

static CGFloat const optionCellHeight = 40;

+ (instancetype)viewWithIcon:(UIImage *)icon titleTemplate:(NSString *)titleTemplate options:(NSArray <NSString*>*)options {
    MDOptionView *view = [[NSBundle mainBundle] loadNibNamed:@"MDOptionView" owner:self options:nil].firstObject;
    view.icon = icon;
    view.options = options;
    view.titleTemplate = titleTemplate;
    [view updateView];
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MDOptionCell" bundle:nil] forCellReuseIdentifier:@"MDOptionCell"];
    
    [self.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titlePressed:)]];
    
    self.selected = NO;
}

- (void)updateView {
    self.iconView.image = self.icon;
    
    [self.tableView reloadData];
    self.titleLabel.text = [NSString stringWithFormat:self.titleTemplate, self.options.firstObject];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:firstIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:firstIndexPath];
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.iconView.tintColor = [UIColor mdBlueColor];
        self.titleLabel.textColor = [UIColor mdBlueColor];
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

- (id)selectedOption {
    return self.options[self.tableView.indexPathForSelectedRow.row];
}

- (void)titlePressed:(UIGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(optionView:didHeaderTap:)]) {
        [self.delegate optionView:self didHeaderTap:sender];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDOptionCell"];
    cell.titleLabel.text = self.options[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.titleLabel.text = [NSString stringWithFormat:self.titleTemplate, self.options[indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return optionCellHeight;
}

@end
