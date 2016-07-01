//
//  FontListViewController.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 7/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "FontListViewController.h"

@interface FontListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *fonts;
@property (nonatomic) NSArray *selectedFont;
@property (nonatomic) UIBarButtonItem *doneButton;
@end

@implementation FontListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedFont = [[NSUserDefaults standardUserDefaults] objectForKey:@"custom_font"];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.fonts = @[[UIFont fontNamesForFamilyName:@"Changa"],
                   [UIFont fontNamesForFamilyName:@"Titillium Web"],
                   [UIFont fontNamesForFamilyName:@"Arima Madurai"],
                   [UIFont fontNamesForFamilyName:@"Lato"],
                   [UIFont fontNamesForFamilyName:@"Yanone Kaffeesatz"]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fontCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.selectedFont) {
        NSInteger index = [self.fonts indexOfObject:self.selectedFont];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)donePressed:(UIBarButtonItem *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedFont forKey:@"custom_font"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSelectedFont:(NSArray *)selectedFont {
    if (selectedFont) {
        self.doneButton.enabled = YES;
    } else {
        self.doneButton.enabled = NO;
    }
    _selectedFont = selectedFont;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fonts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fontNameBold;
    for (NSString *fontName in self.fonts[indexPath.row]) {
        if ([fontName rangeOfString:@"-bold" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            fontNameBold = fontName;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fontCell"];
    cell.textLabel.font = [UIFont fontWithName:fontNameBold size:17];
    cell.textLabel.text = fontNameBold;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedFont = self.fonts[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedFont = nil;
}

@end
