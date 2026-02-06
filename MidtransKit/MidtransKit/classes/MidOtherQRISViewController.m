//
//  MidOtherQRISViewController.m
//  MidtransKit
//
//  Copyright © 2026 Midtrans. All rights reserved.
//

#import "MidOtherQRISViewController.h"
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

@interface MidOtherQRISViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet MIDGopayView *view;
@property (nonatomic) NSArray *guides;
@property (nonatomic) MidtransDirectHeader *headerView;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;
@end

@implementation MidOtherQRISViewController

@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up dismiss button if this is direct payment (single payment method)
    if (self.isDirectPayment) {
        [self showDismissButton:YES];
    }

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

    // Hide GoPay specific elements - always show QRIS flow
    self.view.gopayTopViewWrapper.hidden = YES;
    self.view.gopayTopViewHeightConstraints.constant = 0.0f;
    self.view.topWrapperView.hidden = YES;
    self.view.installGojekButton.hidden = YES;

    // Set button title for QRIS
    [self.view.finishPaymentButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Pay with QRIS"] forState:UIControlStateNormal];

    // Load instructions
    [self loadPaymentGuides];
}

#pragma mark - Private Methods

- (void)loadPaymentGuides {
    NSString *guidePath = [self guidePathForPaymentMethod:MIDTRANS_PAYMENT_OTHER_QRIS];

    if (guidePath == nil) {
        guidePath = [self guidePathForPaymentMethod:MIDTRANS_PAYMENT_GOPAY];
    }

    self.guides = [VTClassHelper instructionsFromFilePath:guidePath];
    [self.view.tableView reloadData];
}

- (NSString *)guidePathForPaymentMethod:(NSString *)paymentMethod {
    NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_ipad_%@", paymentMethod];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];

    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_ipad_%@", paymentMethod] ofType:@"plist"];
    }

    return guidePath;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    [label setText:[VTClassHelper getTranslationFromAppBundleForString:@"How to Pay"]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.guides.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }

    // Show scan QR image for the second instruction (index 1) - always show for other_qris
    if (indexPath.row == 1) {
        UIImage *scanImage = [UIImage imageNamed:@"gopay_scan_2" inBundle:VTBundle compatibleWithTraitCollection:nil];
        cell.imageBottomInstruction.hidden = NO;
        [cell.imageBottomInstruction setImage:scanImage];
        cell.bottomImageInstructionsConstraints.constant = 120.0f;
    }
    [cell setInstruction:self.guides[indexPath.row] number:indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    static VTGuideCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.view.tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
        });
    [cell setInstruction:self.guides[indexPath.row] number:indexPath.row + 1];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

#pragma mark - Actions

- (IBAction)finishPaymentButtonDidTapped:(id)sender {
    [self showLoadingWithText:[VTClassHelper getTranslationFromAppBundleForString:@"Processing your transaction"]];

    // Always use MidtransPaymentOtherQRIS for other_qris payment
    id<MidtransPaymentDetails> paymentDetails = [[MidtransPaymentOtherQRIS alloc] init];
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];

    [[MidtransMerchantClient shared] performTransaction:transaction
                                             completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];

        if (error || !result) {
            [self showToastInviewWithMessage:error.localizedDescription ?: @"Payment failed"];
            return;
        }

        MidQRISDetailViewController *qrisDetailVC = [[MidQRISDetailViewController alloc] initWithToken:self.token paymentMethodName:self.paymentMethod];
        qrisDetailVC.result = result;
        [self.navigationController pushViewController:qrisDetailVC animated:YES];
    }];
}

- (void)totalAmountBorderedViewTapped:(id)sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.transactionDetailWrapper items:self.token.itemDetails grossAmount:self.token.transactionDetails.grossAmount];
}

- (void)backButtonDidTapped:(id)sender {
    if (!self.isDirectPayment) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_CANCELED object:nil];
    }];
}

@end
