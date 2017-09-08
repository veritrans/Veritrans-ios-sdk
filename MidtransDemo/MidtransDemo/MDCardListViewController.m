//
//  MDCardListViewController.m
//  MidtransDemo
//
//  Created by Vanbungkring on 5/5/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDCardListViewController.h"
#import "MDCardTableViewCell.h"
#import <MidtransKit/MidtransKit.h>
#import "MDAddCardViewController.h"
#import "MDSaveCardFooter.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@interface MDCardListViewController ()<UITableViewDelegate,UITableViewDataSource,MidtransUIPaymentViewControllerDelegate>
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
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.maskedCard = [userDefaults objectForKey:@"SAVED_CARD"];
    
    [self.tableView reloadData];
}
- (void)addCardPressed:(id)sender{
    
    NSString *clientkey = @"VT-client-E4f1bsi1LpL1p5cF";
    NSString *merchantServer = @"https://rakawm-snap.herokuapp.com";
    [[MidtransNetworkLogger shared] startLogging];
    [CONFIG setClientKey:clientkey
             environment:MidtransServerEnvironmentSandbox
       merchantServerURL:merchantServer];
    MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initCreditCardForm];
    paymentVC.paymentDelegate = self;
    [self.navigationController presentViewController:paymentVC animated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.maskedCard.count;
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController saveCard:(MidtransMaskedCreditCard *)result{
    NSLog(@"data-->%@",result);
    [self saveCreditCardObject:result];
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController saveCardFailed:(NSError *)error {
    NSLog(@"data-->%@",error);
}

- (void)saveCreditCardObject:(MidtransMaskedCreditCard *)creditCardObject {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfRawCard = [userDefaults objectForKey:@"SAVED_CARD"];
    NSMutableArray *mutableDataArray =[NSMutableArray arrayWithArray:arrayOfRawCard];
    [mutableDataArray addObject:[creditCardObject dictionaryValue]];
    [userDefaults setObject:mutableDataArray forKey:@"SAVED_CARD"];
    [userDefaults objectForKey:@"SAVED_CARD"];
    [userDefaults synchronize];
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *maskedCard = [self.maskedCard objectAtIndex:indexPath.row];
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
