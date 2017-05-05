//
//  MDCardListViewController.m
//  MidtransDemo
//
//  Created by Vanbungkring on 5/5/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDCardListViewController.h"
#import "MDCardTableViewCell.h"
#import "MDSaveCardFooter.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@interface MDCardListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *maskedCard;
@property (nonatomic,strong)MDSaveCardFooter *footerView;

@end

@implementation MDCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Card";
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-60, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"MDSaveCardFooter" owner:self options:nil] lastObject];
    [self.footerView.addCardButton addTarget:self action:@selector(addCardPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = [UIView new];
     [self.tableView registerNib:[UINib nibWithNibName:@"MDCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"MDCardTableViewCell"];
    self.tableView.tableFooterView = self.footerView;
    [self.tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}
- (void)addCardPressed:(id)sender{
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.maskedCard.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MidtransMaskedCreditCard *maskedCard = (MidtransMaskedCreditCard *)[self.maskedCard objectAtIndex:indexPath.row];
    MDCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDCardTableViewCell" forIndexPath:indexPath];
    [cell configureCard:maskedCard];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
