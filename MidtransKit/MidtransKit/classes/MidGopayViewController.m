//
//  MidGopayViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 11/24/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidGopayViewController.h"
#import "MIDGopayView.h"
#import "MidGopayDetailViewController.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MIdtransUIBorderedView.h"
#import "MidtransDirectHeader.h"
#import "VTGuideCell.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface MidGopayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet MIDGopayView *view;
@property (nonatomic) NSArray *guides;
@property (nonatomic) MidtransDirectHeader *headerView;
@end

@implementation MidGopayViewController
@dynamic view;
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                     merchant:(MidtransPaymentRequestV2Merchant *)merchant {
    
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        //self.title = paymentMethod;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GO-PAY";
    self.view.tableView.delegate = self;
    self.view.tableView.dataSource = self;
    self.view.tableView.tableFooterView = [UIView new];
    self.view.tableView.estimatedRowHeight = 60;
     self.view.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view.tableView registerNib:[UINib nibWithNibName:@"MidtransDirectHeader" bundle:VTBundle] forCellReuseIdentifier:@"MidtransDirectHeader"];
    [self.view.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    self.headerView = [self.view.tableView dequeueReusableCellWithIdentifier:@"MidtransDirectHeader"];
    self.view.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    

   
    [self.view.tableView reloadData];
    if (IPAD) {
        self.view.topWrapperView.hidden = YES;
        self.view.topNoticeLabel.text = @"Pastikan aplikasi GO-JEk terinstall pada HP anda";
    } else {
    NSURL *gojekUrl = [NSURL URLWithString:@"gojek://"];
    if (![[UIApplication sharedApplication] canOpenURL:gojekUrl]) {
        self.view.finishPaymentHeightConstraints.constant =  0.0f;
        self.view.topWrapperView.hidden = NO;
        self.view.gopayTopViewHeightConstraints.constant = 0.0f;
        self.view.transactionBottomDetailConstraints.constant = 0.0f;
        
    } else {
        self.view.topWrapperView.hidden = YES;
         self.view.gopayTopViewHeightConstraints.constant = 0.0f;
        }
    }
    
    if (IPAD) {
        NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_ipad_%@", MIDTRANS_PAYMENT_GOPAY];
        NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
        if (guidePath == nil) {
            guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_ipad_%@",MIDTRANS_PAYMENT_GOPAY] ofType:@"plist"];
        }
        self.guides = [VTClassHelper instructionsFromFilePath:guidePath];
         [self.view.tableView reloadData];
    } else {
        NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", MIDTRANS_PAYMENT_GOPAY];
        
        NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
        if (guidePath == nil) {
            guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",MIDTRANS_PAYMENT_GOPAY] ofType:@"plist"];
        }
        self.guides = [VTClassHelper instructionsFromFilePath:guidePath];
         [self.view.tableView reloadData];
    }
   
    
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.guides.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    if (IPAD && indexPath.row == 4) {
        cell.imageBottomInstruction.hidden = NO;
        cell.bottomImageInstructionsConstraints.constant = 120.0f;
    }
    [cell setInstruction:self.guides[indexPath.row] number:indexPath.row+1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IPAD && indexPath.row == 4) {
        return 200;
    }
    else {
        if (IS_IOS8_OR_ABOVE) {
            return UITableViewAutomaticDimension;
        } 
        else {
            static VTGuideCell *cell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                cell = [self.view.tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
            });
            [cell setInstruction:self.guides[indexPath.row] number:indexPath.row+1];
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
        
    }
}
- (IBAction)finishPaymentButtonDidTapped:(id)sender {
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    id<MidtransPaymentDetails>paymentDetails;
    paymentDetails = [[MidtransPaymentGOPAY alloc] init];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error) {
                                                 [self hideLoading];
                                                 MidGopayDetailViewController *gopayDetailVC = [[MidGopayDetailViewController  alloc] initWithToken:self.token paymentMethodName:self.paymentMethod];
                                                 [self.navigationController pushViewController:gopayDetailVC animated:YES];
//                                                 if (error) {
//                                                     [self showToastInviewWithMessage:error.description];
//                                                 }
//                                                 else {
//
//                                                     NSLog(@"result->%@",result);
//                                                 }
                                             }];
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
