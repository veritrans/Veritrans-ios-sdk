//
//  SamplePaymentListViewController.m
//  VTDirectDemo
//
//  Created by Arie on 8/31/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "SamplePaymentListViewController.h"
#import <MBProgressHUD.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/VTPaymentListModel.h>
#import <MidtransCoreKit/PaymentRequestDataModels.h>
#import "SamplePaymentListTableViewCell.h"
@interface SamplePaymentListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *paymentList;
@property (nonatomic,strong)NSMutableArray *paymentMethodList;
@end

@implementation SamplePaymentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentMethodList = [NSMutableArray new];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(dismissModalViewControllerAnimated:)];
    
    self.navigationItem.leftBarButtonItem = doneButton;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"paymentlist" ofType:@"plist"];
    self.paymentList = [NSArray arrayWithContentsOfFile:path];
    
    [[VTMerchantClient sharedClient] requestPaymentlistWithToken:self.transactionToken.tokenId
                                                      completion:^(PaymentRequestResponse * _Nullable response, NSError * _Nullable error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.title = response.merchantData.displayName;
         if (response) {
             NSInteger grandTotalAmount = [response.transactionData.transactionDetails.amount integerValue];
             // [self.tableView reloadData];
             if (response.transactionData.enabledPayments.count) {
                 for (int x=0; x<response.transactionData.enabledPayments.count; x++) {
                     for (int i = 0; i<self.paymentList.count; i++) {
                         VTPaymentListModel *paymentmodel= [[VTPaymentListModel alloc]initWithDictionary:self.paymentList[i]];
                         if ([response.transactionData.enabledPayments[x] isEqualToString:paymentmodel.localPaymentIdentifier]) {
                             [self.paymentMethodList addObject:paymentmodel];
                         }
                     }
                 }
             }
             [self.tableView reloadData];
             
         }
         else {
             //todo what should happens when payment request is failed;
         }
     }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paymentMethodList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTPaymentListModel *paymentMethod = self.paymentMethodList[indexPath.row];
    SamplePaymentListTableViewCell *cell = (SamplePaymentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SamplePaymentListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SamplePaymentListTableViewCell" owner:self options:nil] firstObject];
        [tableView registerNib:[UINib nibWithNibName:@"SamplePaymentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SamplePaymentListTableViewCell"];
    }
    [cell configurePaymetnList:paymentMethod];
    return cell;
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
