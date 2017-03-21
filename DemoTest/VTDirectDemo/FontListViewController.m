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
@property (nonatomic) UIBarButtonItem *doneButton;
@end

@implementation FontListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fonts = @[[UIFont fontNamesForFamilyName:@"Changa"],
                   [UIFont fontNamesForFamilyName:@"Titillium Web"],
                   [UIFont fontNamesForFamilyName:@"Arima Madurai"],
                   [UIFont fontNamesForFamilyName:@"Lato"],
                   [UIFont fontNamesForFamilyName:@"Yanone Kaffeesatz"]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fontCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fonts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fontNameBold;
    for (NSString *fontName in self.fonts[indexPath.row]) {
        if ([fontName rangeOfString:@"-regular" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            fontNameBold = fontName;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fontCell"];
    cell.textLabel.font = [UIFont fontWithName:fontNameBold size:17];
    cell.textLabel.text = fontNameBold;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectFontNames:)]) {
        [self.delegate didSelectFontNames:self.fonts[indexPath.row]];
    }
}

@end
