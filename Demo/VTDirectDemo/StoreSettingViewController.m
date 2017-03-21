//
//  StoreSettingViewController.m
//  VTDirectDemo
//
//  Created by Vanbungkring on 3/14/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "StoreSettingViewController.h"
#import "SNPAccordion.h"
#import "ProductDetailViewController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@interface StoreSettingViewController ()<UITableViewDataSource,UITableViewDelegate,SNPAccordionDelegate>
@property (weak, nonatomic) IBOutlet UIView *storeSettingWrapperView;
@property (nonatomic,strong) SNPAccordion *accordion;
@property (nonatomic,strong)NSDictionary *menu;
@property (nonatomic,strong)NSArray *key;
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
    self.accordion.headerFont = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    self.accordion.headerTitleColor = [UIColor lightGrayColor];
    self.accordion.headerColor = [UIColor whiteColor];
    [self.storeSettingWrapperView addSubview:self.accordion];
    
    // Read plist from bundle and get Root Dictionary out of it
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"payment-menu" ofType:@"plist"]];
    self.menu = dictRoot;
    self.accordion.headerHeight = 40;
    self.key =@[@"Credit Card Payment",@"3D Secure",@"Issuing Bank",@"Custom Expiry",@"Save Card",@"Pre auth"];
    for (int i=0; i<self.menu.count; i++) {
        UITableView *section = [[UITableView alloc] init];
        [section setTag:i];
        section.tableFooterView = [UIView new];
        [section setDelegate:self];
        [section setDataSource:self];
        [self.accordion addSectionWithTitle:[self.key objectAtIndex:i]
                                    andView:section andIcon:[UIImage imageNamed:[[self.key objectAtIndex:i] lowercaseString]] withTotalContent:10];
        [section reloadData];
    }

    

}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.menu objectForKey:[self.key objectAtIndex:tableView.tag]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting_cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setting_cell"];
    }
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:13];
    cell.textLabel.text = [[[self.menu objectForKey:[self.key objectAtIndex:tableView.tag]] objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.textColor = [UIColor colorWithRed:0.46f green:0.46f blue:0.46f alpha:1.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (BOOL)shouldAutorotate {
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (IBAction)launchAppButtonDidTapped:(id)sender {
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}
- (void)accordion:(SNPAccordion *)accordion
   willSelectView:(UIView *)view
        withTitle:(NSString *)title
          andIcon:(UIImage *)icon {

}
- (BOOL)accordion:(SNPAccordion *)accordion
 shouldSelectView:(UIView *)view
        withTitle:(NSString *)title
          andIcon:(UIImage *)icon;
{
    return YES;
}
 #pragma mark - Navigation


@end
