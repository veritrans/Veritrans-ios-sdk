//
//  MDAlertViewController.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 5/4/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDAlertViewController.h"
#import "MDAlertInputCell.h"
#import "MDAlertRadioCell.h"
#import "MDAlertCheckCell.h"
#import "MDUtils.h"

#define MDAlertInputCellHeight 50.f

@interface MDAlertViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *keyboardHeightConstraint;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UIButton *applyButton;
@property (nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) IBOutlet UIView *dimmedView;

@property (nonatomic) NSString *alertTitle;
@property (nonatomic) NSArray <NSString*>*radioButtons;
@property (nonatomic) NSArray <NSString*>*checkLists;
@property (nonatomic) NSArray <NSString*>*textfields;

@property (nonatomic) MDAlertInputCell *inputCell;
@end

@implementation MDAlertViewController

+ (MDAlertViewController *)alertWithTitle:(NSString *)title radioButtons:(NSArray <NSString*>*)radioButtons {
    MDAlertViewController *vc = [[MDAlertViewController alloc] initWithNibName:@"MDAlertViewController"
                                                                        bundle:nil];
    vc.alertTitle = title;
    vc.radioButtons = radioButtons;
    vc.type = MDAlertOptionTypeRadio;
    return vc;
}

+ (MDAlertViewController *)alertWithTitle:(NSString *)title checkLists:(NSArray <NSString*>*)checkLists {
    MDAlertViewController *vc = [[MDAlertViewController alloc] initWithNibName:@"MDAlertViewController"
                                                                        bundle:nil];
    vc.alertTitle = title;
    vc.checkLists = checkLists;
    vc.type = MDAlertOptionTypeCheck;
    return vc;
}

+ (MDAlertViewController *)alertWithTitle:(NSString *)title
                           predefinedText:(NSString *)predefinedText
                         inputPlaceholder:(NSString *)placeholder {
    MDAlertViewController *vc = [[MDAlertViewController alloc] initWithNibName:@"MDAlertViewController"
                                                                        bundle:nil];
    vc.alertTitle = title;
    vc.predefinedInputText = predefinedText;
    vc.inputPlaceholder = placeholder;
    vc.type = MDAlertOptionTypeInput;
    return vc;
}

+ (MDAlertViewController *)alertWithTitle:(NSString *)title
                       multipleTextfields:(NSArray <NSString*>*)multipleTextfields
                         inputPlaceholder:(NSString *)placeholder {
    MDAlertViewController *vc = [[MDAlertViewController alloc] initWithNibName:@"MDAlertViewController"
                                                                        bundle:nil];
    vc.alertTitle = title;
    vc.multipleInputTexts = multipleTextfields;
    vc.inputPlaceholder = placeholder;
    vc.type = MDAlertOptionTypeMultipleInput;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MDAlertInputCell" bundle:nil] forCellReuseIdentifier:@"MDAlertInputCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MDAlertRadioCell" bundle:nil] forCellReuseIdentifier:@"MDAlertRadioCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MDAlertCheckCell" bundle:nil] forCellReuseIdentifier:@"MDAlertCheckCell"];
    [self updateTableViewHeight];
    
    self.titleLabel.text = self.alertTitle;
    
    if (self.type == MDAlertOptionTypeInput) {
        self.inputCell = [self.tableView dequeueReusableCellWithIdentifier:@"MDAlertInputCell"];
        self.inputCell.textField.placeholder = self.inputPlaceholder;
        self.inputCell.textField.text = self.predefinedInputText;
        [self.inputCell.textField addTarget:self action:@selector(inputTextChanged:) forControlEvents:UIControlEventEditingChanged];
        self.applyButton.enabled = NO;
    }
    else if (self.type == MDAlertOptionTypeRadio) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.radioButtons indexOfObject:self.predefinedRadio] inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
    else if (self.type == MDAlertOptionTypeCheck) {
        self.tableView.allowsMultipleSelection = YES;
        for (int i=0; i < self.checkLists.count; i++) {
            if ([self.predefinedCheckLists containsObject:self.checkLists[i]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            }
        }
    }
    else if (self.type == MDAlertOptionTypeMultipleInput) {
        if (self.multipleInputTexts == nil) {
            self.multipleInputTexts = @[@"", @"", @""];
        }
        self.applyButton.enabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSTimeInterval duration;
    CGRect kbFrame;
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&kbFrame];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.keyboardHeightConstraint.constant = CGRectGetHeight(kbFrame);
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration;
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.keyboardHeightConstraint.constant = 0;
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)updateTableViewHeight {
    CGFloat height= 0;
    
    switch (self.type) {
        case MDAlertOptionTypeInput:
            height = MDAlertInputCellHeight;
            break;
        case MDAlertOptionTypeRadio:
            for (int i=0; i < self.radioButtons.count; i++) {
                height += 44;
            }
            break;
        case MDAlertOptionTypeMultipleInput:
            height += 3 * MDAlertInputCellHeight;
            break;
        default:
            for (int i=0; i < self.checkLists.count; i++) {
                height += 44;
            }
            break;
    }
    self.tableHeightConstraint.constant = height;
}

- (void)show {
    self.view.hidden = YES;
    
    UIViewController *rootvc = [MDUtils rootViewController].navigationController? : [MDUtils rootViewController];
    [rootvc addChildViewController:self];
    [self didMoveToParentViewController:rootvc];
    [rootvc.view addSubview:self.view];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [rootvc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:0 views:@{@"view":self.view}]];
    [rootvc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:0 views:@{@"view":self.view}]];
    
    self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.01);
    self.dimmedView.alpha = 0;
    self.view.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.dimmedView.alpha = 1;
    }];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismiss {
    self.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.18 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.01);
    } completion:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.dimmedView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self willMoveToParentViewController:nil];
        [self removeFromParentViewController];
    }];
}

- (IBAction)cancelTap:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(alertViewController_didCancel:)]) {
        [self.delegate alertViewController_didCancel:self];
    }
}

- (IBAction)applyTap:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.type == MDAlertOptionTypeRadio) {
        if ([self.delegate respondsToSelector:@selector(alertViewController:didApplyRadio:)]) {
            NSUInteger index = self.tableView.indexPathForSelectedRow.row;
            [self.delegate alertViewController:self didApplyRadio:self.radioButtons[index]];
        }
    }
    else if (self.type == MDAlertOptionTypeInput) {
        if ([self.delegate respondsToSelector:@selector(alertViewController:didApplyInput:)]) {
            [self.delegate alertViewController:self didApplyInput:self.inputText];
        }
    }
    else if (self.type == MDAlertOptionTypeMultipleInput) {
        if ([self.delegate respondsToSelector:@selector(alertViewController:didApplyMultipleInput:)]) {
            [self.delegate alertViewController:self didApplyMultipleInput:self.multipleInputTexts];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(alertViewController:didApplyCheck:)]) {
            NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
            NSMutableArray *checkedList = [NSMutableArray new];
            for (NSIndexPath *indexPath in indexPaths) {
                [checkedList addObject:self.checkLists[indexPath.row]];
            }
            [self.delegate alertViewController:self didApplyCheck:checkedList];
        }
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == MDAlertOptionTypeRadio) {
        return self.radioButtons.count;
    }
    else if (self.type == MDAlertOptionTypeInput) {
        return 1;
    }
    else if (self.type == MDAlertOptionTypeMultipleInput) {
        return 3;
    }
    else {
        return self.checkLists.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == MDAlertOptionTypeRadio) {
        MDAlertRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDAlertRadioCell"];
        cell.titleLabel.text = self.radioButtons[indexPath.row];
        return cell;
    }
    else if (self.type == MDAlertOptionTypeInput) {
        return self.inputCell;
    }
    else if (self.type == MDAlertOptionTypeMultipleInput) {
        MDAlertInputCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MDAlertInputCell"];
        cell.textField.placeholder = self.inputPlaceholder;
        cell.textField.text = self.multipleInputTexts[indexPath.row];
        cell.textField.tag = indexPath.row;
        [cell.textField addTarget:self action:@selector(inputTextChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
    else {
        MDAlertCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDAlertCheckCell"];
        cell.titleLabel.text = self.checkLists[indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == MDAlertOptionTypeInput || self.type == MDAlertOptionTypeMultipleInput) {
        return MDAlertInputCellHeight;
    }
    else {
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)inputTextChanged:(UITextField *)textField {
    if (self.type == MDAlertOptionTypeInput) {
        self.inputText = textField.text;
        self.applyButton.enabled = textField.text.length > 0;
    }
    else if (self.type == MDAlertOptionTypeMultipleInput) {
        NSMutableArray *mutable = [NSMutableArray arrayWithArray:self.multipleInputTexts];
        [mutable replaceObjectAtIndex:textField.tag withObject:textField.text];
        self.multipleInputTexts = [NSArray arrayWithArray:mutable];
        self.applyButton.enabled = [self.multipleInputTexts componentsJoinedByString:@""].length > 0;
    }
}

@end
