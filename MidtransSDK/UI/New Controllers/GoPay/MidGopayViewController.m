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
#import "MIDConstants.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface MidGopayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet MIDGopayView *view;
@property (nonatomic) NSArray *guides;
@property (nonatomic) MidtransDirectHeader *headerView;
@property (nonatomic) MIDGopayResult *paymentResult;
@end

@implementation MidGopayViewController

@dynamic view;

- (void)handleGopayStatus:(id)sender {
    [MIDClient getPaymentStatusWithToken:self.snapToken
                                completion:^(MIDPaymentResult * _Nullable result, NSError * _Nullable error)
     {
         if (error) {
             [self handleTransactionError:error];
         } else {
             [self handleTransactionSuccess:result];
         }
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleGopayStatus:)
                                                 name:notifGopayStatus
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
    self.view.amountLabel.text = self.info.transaction.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.info.transaction.orderID;
    
    
    
    [self.view.tableView reloadData];
    
    if (IPAD) {
        self.view.topWrapperView.hidden = YES;
        self.view.topNoticeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Please complete your ‘GO-PAY‘ payment via ‘GO-JEK‘ app"];
    } else {
        NSURL *gojekUrl = [NSURL URLWithString:MIDTRANS_GOPAY_PREFIX];
        if ([[UIApplication sharedApplication] canOpenURL:gojekUrl]) {
            self.view.gopayTopViewHeightConstraints.constant = 0.0f;
            self.view.topWrapperView.hidden = YES;
            
        } else {
            self.view.topWrapperView.hidden = NO;
            self.view.transactionBottomDetailConstraints.constant = 0.0f;
            self.view.finishPaymentHeightConstraints.constant =  0.0f;
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

- (void)openGojekAppWithResult:(MIDGopayResult *)result {
    _paymentResult = result;
    
    NSURL *gojekConstructURL = [NSURL URLWithString:result.deepLinkURL];
    if ([[UIApplication sharedApplication] canOpenURL:gojekConstructURL]) {
        [[UIApplication sharedApplication] openURL:gojekConstructURL];
    }
}

- (IBAction)finishPaymentButtonDidTapped:(id)sender {
    if (_paymentResult) {
        [self openGojekAppWithResult:_paymentResult];
        return;
    }
    
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];
    
    [MIDEWalletCharge gopayWithToken:self.snapToken completion:^(MIDGopayResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            [self showToastInviewWithMessage:error.localizedDescription];
        }
        else {
            if (IPAD) {
                MidGopayDetailViewController *gopayDetailVC = [[MidGopayDetailViewController alloc] initWithResult:result paymentMethod:self.paymentMethod];
                [self.navigationController pushViewController:gopayDetailVC animated:YES];
                
            } else {
                NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:result.dictionaryValue};
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
                
                [self openGojekAppWithResult:result];
                
                if (UICONFIG.hideStatusPage) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }
    }];
}

@end
