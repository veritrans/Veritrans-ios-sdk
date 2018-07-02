//
//  SNPPostPaymentGeneralViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 6/9/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPostPaymentGeneralViewController.h"
#import "SNPPostPaymentGeneralView.h"
#import "UIImage+Scale.h"
#import "SNPPostPaymentGeneralHeader.h"
#import "MidtransUIToast.h"
#import "VTClassHelper.h"
#import "VTGuideCell.h"
#import "MIDBarcode39Generator.h"
#import "UILabel+Boldify.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransTransactionDetailViewController.h"
#import "MIdtransUIBorderedView.h"
@interface SNPPostPaymentGeneralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (strong, nonatomic) IBOutlet SNPPostPaymentGeneralView *view;
@property (nonatomic,strong) NSArray *instrunctions;
@property (nonatomic) BOOL showInstructions;
@property (nonatomic) SNPPostPaymentGeneralHeader *headerView;
@end

@implementation SNPPostPaymentGeneralViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = [self.paymentMethod.title capitalizedString];
    [self.navigationItem setHidesBackButton:YES];
    [self showBackButton:NO];
    self.view.tableView.estimatedRowHeight = 60;
    self.view.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    [self.view.tableView registerNib:[UINib nibWithNibName:@"SNPPostPaymentGeneralHeader" bundle:VTBundle] forCellReuseIdentifier:@"SNPPostPaymentGeneralHeader"];
    self.headerView = [self.view.tableView dequeueReusableCellWithIdentifier:@"SNPPostPaymentGeneralHeader"];
    self.headerView.topTextLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"kioson.pending.code-title"];
    NSString *expireDate;
    if ([self.title isEqualToString:@"Kioson"]) {
        expireDate = [self.transactionResult.additionalData objectForKey:@"kioson_expire_time"];
    }
    else  if ([self.title isEqualToString:@"Indomaret"]) {
        expireDate =[self.transactionResult.additionalData objectForKey:@"indomaret_expire_time"];
        [self.view.tableView registerNib:[UINib nibWithNibName:@"SNPPostPaymentIndomaretHeader" bundle:VTBundle] forCellReuseIdentifier:@"SNPPostPaymentIndomaretHeader"];
        self.headerView = [self.view.tableView dequeueReusableCellWithIdentifier:@"SNPPostPaymentIndomaretHeader"];
        self.headerView.indomaretAccountNumber.text = self.transactionResult.indomaretPaymentCode;
        [self.headerView.showInstructionsButton addTarget:self action:@selector(showInstructionsButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
        self.headerView.indomaretBarcodeCode.image =
        [MIDBarcode39Generator code39ImageFromString:self.transactionResult.indomaretPaymentCode Width:400 Height:self.headerView.barcodeImageHeightConstant.constant];
        self.headerView.indomaretBarcodeCode.contentMode = UIViewContentModeScaleToFill;
        self.headerView.topTextLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"kioson.pending.code-title"];
    } else {
        [self.view.tableView registerNib:[UINib nibWithNibName:@"SNPPostPaymentGeneralHeader" bundle:VTBundle] forCellReuseIdentifier:@"SNPPostPaymentGeneralHeader"];
        self.headerView = [self.view.tableView dequeueReusableCellWithIdentifier:@"SNPPostPaymentGeneralHeader"];
    }
    
     self.headerView.expiredTimeLabel.text = [NSString stringWithFormat:@"%@ %@",[VTClassHelper getTranslationFromAppBundleForString:@"Please complete payment before: %@"],expireDate];
    [self.headerView updateFocusIfNeeded];
    self.view.tableView.tableHeaderView = self.headerView;
    self.headerView.vaTextField.text = self.transactionResult.indomaretPaymentCode;
    
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.paymentMethod.internalBaseClassIdentifier];
    
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.internalBaseClassIdentifier] ofType:@"plist"];
    }
    self.instrunctions = [VTClassHelper instructionsFromFilePath:guidePath];
    
     self.totalAmountLabel.text = [self.token.itemDetails formattedPriceAmount];
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
    [self.headerView.vaCopyButton addTarget:self action:@selector(copyButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.tableView reloadData];
    [self.view.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
}
- (void)showInstructionsButtonDidTapped{
    self.showInstructions = !self.showInstructions;
    [self.view.tableView reloadData];
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.view.totalAmountBorderedView items:self.token.itemDetails];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showInstructions?self.instrunctions.count:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    [cell setInstruction:self.instrunctions[indexPath.row] number:indexPath.row+1];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        if (indexPath.row == 0) {
            return 138.0f;
        }
        else {
        static VTGuideCell *cell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cell = [self.view.tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
        });
            if(indexPath.row %2 ==0) {
                 cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
            }
        [cell setInstruction:self.instrunctions[indexPath.row] number:indexPath.row+1];
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)copyButtonDidTapped:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.headerView.vaTextField.text];
    [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self.view];
}
- (IBAction)finishPaymentDidtapped:(id)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.transactionResult};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
