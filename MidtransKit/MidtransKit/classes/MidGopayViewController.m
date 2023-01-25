//
//  MidGopayViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 11/24/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidGopayViewController.h"
#import "MIDGopayView.h"
#import "MidQRISDetailViewController.h"
#import "VTClassHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MIdtransUIBorderedView.h"
#import "MidtransDirectHeader.h"
#import "MidtransUINextStepButton.h"
#import "VTGuideCell.h"
#import "MidtransUIConfiguration.h"
#import "MidtransTransactionDetailViewController.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface MidGopayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet MIDGopayView *view;
@property (nonatomic) NSArray *guides;
@property (nonatomic) MidtransDirectHeader *headerView;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;
@end

@implementation MidGopayViewController {
    MidtransTransactionResult *payResult;
}

@dynamic view;
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                     merchant:(MidtransPaymentRequestV2Merchant *)merchant {
    
    if (self = [super initWithToken:token paymentMethodName:paymentMethod]) {
        //self.title = paymentMethod;
    }
    return self;
}

- (void)handleGopayStatus:(id)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_CURRENT_TOKEN];
    [[MidtransMerchantClient shared] performCheckStatusTransactionWithToken:token completion:^(MidtransTransactionResult * _Nullable result, NSError * _Nullable error) {
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
                                             selector:@selector(handleGopayStatus:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    self.title = self.paymentMethod.title;
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
    [self.view.transactionDetailWrapper addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    
    [self.view.tableView reloadData];
    
    if (IPAD) {
        self.view.topWrapperView.hidden = YES;
        self.view.gopayTopViewHeightConstraints.constant = 0.0f;
        self.view.topNoticeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Please complete your ‘GoPay‘ payment via ‘Gojek‘ app"];
    } else {
        if (MidtransConfig.shared.environment == MidtransServerEnvironmentProduction) {
            NSURL *gojekUrl = [NSURL URLWithString:MIDTRANS_GOPAY_PREFIX_OLD];
            if ([[UIApplication sharedApplication] canOpenURL:gojekUrl]) {
                self.view.gopayTopViewHeightConstraints.constant = 0.0f;
                self.view.topWrapperView.hidden = YES;
                
            } else {
                self.view.topWrapperView.hidden = NO;
                self.view.transactionBottomDetailConstraints.constant = 0.0f;
                self.view.finishPaymentHeightConstraints.constant =  0.0f;
            }
        } else {
            self.view.gopayTopViewHeightConstraints.constant = 0.0f;
            self.view.topWrapperView.hidden = YES;
        }
        
    }
    
    
    [self.view.finishPaymentButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Pay Now with GoPay"] forState:UIControlStateNormal];
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
    [label setText:@"How to Pay"];
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
    if (IPAD && indexPath.row == 1) {
        cell.imageBottomInstruction.hidden = NO;
        [cell.imageBottomInstruction setImage:[UIImage imageNamed:@"gopay_scan_2" inBundle:VTBundle compatibleWithTraitCollection:nil]];
        cell.bottomImageInstructionsConstraints.constant = 120.0f;
    }
    [cell setInstruction:self.guides[indexPath.row] number:indexPath.row+1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (IBAction)installGOJEKappButtonDidTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GOJEK_APP_ITUNES_LINK]];
}
- (void)openGojekAppWithResult:(MidtransTransactionResult *)result {
    NSString *gojekDeeplinkString = [result.additionalData objectForKey:@"deeplink_url"];
    NSURL *deeplinkURL = [NSURL URLWithString:gojekDeeplinkString];
    if ([[UIApplication sharedApplication] canOpenURL:deeplinkURL]) {
        [[UIApplication sharedApplication] openURL:deeplinkURL];
    }
}

- (IBAction)finishPaymentButtonDidTapped:(id)sender {
    if (payResult) {
        [self openGojekAppWithResult:payResult];
        return;
    }
    
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    id<MidtransPaymentDetails>paymentDetails;
    if (IPAD) {
        paymentDetails = [[MidtransPaymentQRIS alloc]initWithAcquirer:MIDTRANS_PAYMENT_GOPAY];
    } else {
         paymentDetails = [[MidtransPaymentShopeePay alloc] init];
    }
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    
    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        if (error || !result) {
            [self showToastInviewWithMessage:error.description];
        }
        else {
            if (IPAD) {
                MidQRISDetailViewController *gopayDetailVC = [[MidQRISDetailViewController  alloc] initWithToken:self.token paymentMethodName:self.paymentMethod];
                gopayDetailVC.result = result;
                [self.navigationController pushViewController:gopayDetailVC animated:YES];
            } else {
                payResult = result;                
                [self openGojekAppWithResult:result];
            }
            
        }
    }];
}

- (void)totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.transactionDetailWrapper items:self.token.itemDetails grossAmount:self.token.transactionDetails.grossAmount];
}

- (void)backButtonDidTapped:(id)sender {
    
    if (payResult) {
        NSString *title;
        NSString *content;
        title = [VTClassHelper getTranslationFromAppBundleForString:@"Finish Payment"];
        content = [VTClassHelper getTranslationFromAppBundleForString:@"Make sure payment has been completed within the Gojek app."];
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:content
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
            NSLog(@"Cancel action");
        }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:payResult};
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
            }];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        if (self.isDirectPayment == YES) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_CANCELED object:nil];
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
