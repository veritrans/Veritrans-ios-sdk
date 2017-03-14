//
//  StoreSettingViewController.m
//  VTDirectDemo
//
//  Created by Vanbungkring on 3/14/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "StoreSettingViewController.h"
#import "SNPAccordion.h"
@interface StoreSettingViewController ()<UITableViewDataSource,UITableViewDelegate,OCBorghettiViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *storeSettingWrapperView;
@property (nonatomic,strong) SNPAccordion *accordion;
@end

@implementation StoreSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setupAccordion];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupAccordion {
    self.accordion = [[SNPAccordion alloc] initWithFrame:CGRectMake(0, 0, self.storeSettingWrapperView.frame.size.width, self.storeSettingWrapperView.frame.size.height)];
    self.accordion.headerHeight = 40;
//    
    self.accordion.headerFont = [UIFont fontWithName:@"SourceSans-Pro" size:16];
    self.accordion.headerTitleColor = [UIColor lightGrayColor];
    self.accordion.headerColor = [UIColor lightGrayColor];
    [self.storeSettingWrapperView addSubview:self.accordion];
    
    // Section One
    self.accordion.headerHeight = 40;
    UITableView *sectionOne = [[UITableView alloc] init];
    [sectionOne setTag:1];
    [sectionOne setDelegate:self];
    [sectionOne setDataSource:self];
    [self.accordion addSectionWithTitle:@"Section One"
                                andView:sectionOne andIcon:nil];
    
    // Section Two
    UITableView *sectionTwo = [[UITableView alloc] init];
    [sectionTwo setTag:2];
    [sectionTwo setDelegate:self];
    [sectionTwo setDataSource:self];
    [self.accordion addSectionWithTitle:@"Section Two"
                                andView:sectionTwo andIcon:nil];
    
    // Section Three
    UITableView *sectionThree = [[UITableView alloc] init];
    [sectionThree setTag:3];
    [sectionThree setDelegate:self];
    [sectionThree setDataSource:self];
    [self.accordion addSectionWithTitle:@"Section Three"
                                andView:sectionThree andIcon:nil];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"borghetti_cell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"borghetti_cell"];
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    cell.textLabel.text = [NSString stringWithFormat:@"Table %@ - Cell %@", @(tableView.tag), @(indexPath.row)];
    cell.textLabel.textColor = [UIColor colorWithRed:0.46f green:0.46f blue:0.46f alpha:1.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (IBAction)launchAppButtonDidTapped:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
