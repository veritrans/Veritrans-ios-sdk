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
#import "MidtransUINextStepButton.h"
#import "VTGuideCell.h"
#import "MidtransUIConfiguration.h"
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"view did appear");
}
- (void)handleGopayStatus{
    [[MidtransMerchantClient shared] performCheckStatusTransactionWcompletion:^(MidtransTransactionResult * _Nullable result, NSError * _Nullable error) {
        if (!error) {
            if (result.statusCode == 200) {
                [self handleTransactionSuccess:result];
            }
        } else {
            [self handleSaveCardError:error];
        }
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleGopayStatus)
                                                 name:NOTIFICATION_GOPAY_STATUS
                                               object:nil];
    
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
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
    

   
    [self.view.tableView reloadData];
    
    if (IPAD) {
        self.view.topWrapperView.hidden = YES;
        self.view.topNoticeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Please complete your ‘GO-PAY‘ payment via ‘GO-JEK‘ app"];
    } else {
    NSURL *gojekUrl = [NSURL URLWithString:MIDTRANS_GOPAY_PREFIX];
    if (![[UIApplication sharedApplication] canOpenURL:gojekUrl]) {
        self.view.finishPaymentHeightConstraints.constant =  0.0f;
        self.view.topWrapperView.hidden = NO;
        self.view.transactionBottomDetailConstraints.constant = 0.0f;
        
    } else {
        self.view.topWrapperView.hidden = YES;
         self.view.gopayTopViewHeightConstraints.constant = 0.0f;
        }
    }
    
    
[self.view.finishPaymentButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Pay Now with GO-PAY"] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"gopay_button" inBundle:VTBundle compatibleWithTraitCollection:nil];
    
    [self.view.finishPaymentButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.view.finishPaymentButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    self.view.finishPaymentButton.imageView.tintColor = [UIColor whiteColor];
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    /* Section header is in 0th index... */
    [label setText:@"Instructions"];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.guides.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    if(indexPath.row %2 ==0) {
          cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }
    if (IPAD && indexPath.row == 3) {
        cell.imageBottomInstruction.hidden = NO;
         [cell.imageBottomInstruction setImage:[UIImage imageNamed:@"gopay_scan_1" inBundle:VTBundle compatibleWithTraitCollection:nil]];
        cell.bottomNotes.hidden = NO;
        cell.bottomImageInstructionsConstraints.constant = 120.0f;
    }
    if (IPAD && indexPath.row == 4) {
        cell.imageBottomInstruction.hidden = NO;
        [cell.imageBottomInstruction setImage:[UIImage imageNamed:@"gopay_scan_2" inBundle:VTBundle compatibleWithTraitCollection:nil]];
        cell.bottomImageInstructionsConstraints.constant = 120.0f;
    }
    [cell setInstruction:self.guides[indexPath.row] number:indexPath.row+1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IPAD && indexPath.row == 3) {
        return 200;
    }
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
- (IBAction)installGOJEKappButtonDidTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GOJEK_APP_ITUNES_LINK]];
}
- (IBAction)finishPaymentButtonDidTapped:(id)sender {
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    id<MidtransPaymentDetails>paymentDetails;
    paymentDetails = [[MidtransPaymentGOPAY alloc] init];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error) {
                                                 [self hideLoading];
                                                 if (error || !result) {
                                                     [self showToastInviewWithMessage:error.description];
                                                 }
                                                 else {
                                                     if (IPAD) {
                                                         MidGopayDetailViewController *gopayDetailVC = [[MidGopayDetailViewController  alloc] initWithToken:self.token paymentMethodName:self.paymentMethod];
                                                         gopayDetailVC.result = result;
                                                         [self.navigationController pushViewController:gopayDetailVC animated:YES];
                                                     } else {
                                                         NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:result};
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
                                                         NSURL *gojekConstructURL = [NSURL URLWithString:[result.additionalData objectForKey:@"deeplink_url"]];
                                                         if ([[UIApplication sharedApplication] canOpenURL:gojekConstructURL]) {
                                                             [[UIApplication sharedApplication] openURL:gojekConstructURL];
                                                         }
                                                         if (UICONFIG.hideStatusPage) {
                                                             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                         } else {
                                                             [self handleGopayStatus];
                                                         }
                                                         
                                                     }
                                                    
                                                 }
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
