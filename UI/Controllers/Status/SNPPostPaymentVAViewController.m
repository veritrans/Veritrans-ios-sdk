//
//  SNPPostPaymentVAViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 4/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPostPaymentVAViewController.h"
#import "SNPPostPaymentHeader.h"
#import "SNPPostPaymentHeaderBillPay.h"
#import "VTClassHelper.h"
#import "SNPPostPaymentFooter.h"
#import "MidtransUIToast.h"
#import "VTGuideCell.h"
#import "UILabel+Boldify.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransTransactionDetailViewController.h"
#import "MidtransUIThemeManager.h"
#import "MidtransDeviceHelper.h"
#import "MIDConstants.h"

@interface SNPPostPaymentVAViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableVIewConstraints;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *mainInstructions;
@property (nonatomic) NSArray *subInstructions;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic,strong) NSString *instructionUrl;
@property (nonatomic) SNPPostPaymentHeader *headerView;
@property (nonatomic) SNPPostPaymentHeaderBillPay *headerViewBillPay;
@property (nonatomic) SNPPostPaymentFooter *footerView;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;

@property (nonatomic) MIDPaymentResult *result;

@end

@implementation SNPPostPaymentVAViewController

- (instancetype)initWithPaymentMethod:(MIDPaymentDetail *)paymentMethod
                        paymentResult:(MIDPaymentResult *)result {
    if (self = [super initWithPaymentMethod:paymentMethod]) {
        self.result = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self showBackButton:NO];
    self.title = self.paymentMethod.title;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.paymentMethod.title isEqualToString:@"Mandiri"] || [self.paymentMethod.title isEqualToString:@"Other ATM Network"]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"SNPPostPaymentHeaderBillPay" bundle:VTBundle] forCellReuseIdentifier:@"SNPPostPaymentHeaderBillPay"];
        self.headerViewBillPay = [self.tableView dequeueReusableCellWithIdentifier:@"SNPPostPaymentHeaderBillPay"];
        if ([self.paymentMethod.title isEqualToString:@"Other ATM Network"]) {
            self.headerViewBillPay.vaNumberLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Virtual Account Number"];
            self.headerViewBillPay.companyCodeLabel.text =[VTClassHelper getTranslationFromAppBundleForString:@"Bank Code"];
        }
        
    }
    else {
        [self.tableView registerNib:[UINib nibWithNibName:@"SNPPostPaymentHeader" bundle:VTBundle] forCellReuseIdentifier:@"SNPPostPaymentHeader"];
        self.headerView = [self.tableView dequeueReusableCellWithIdentifier:@"SNPPostPaymentHeader"];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"SNPPostPaymentFooter" bundle:VTBundle] forCellReuseIdentifier:@"SNPPostPaymentFooter"];
    self.totalAmountLabel.text = [self.info.items formattedPriceAmount];
    self.orderIdLabel.text = self.info.transaction.orderID;
    [self.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    
    self.footerView = [self.tableView dequeueReusableCellWithIdentifier:@"SNPPostPaymentFooter"];
    [self.footerView.downloadInstructionButton addTarget:self action:@selector(downloadButtonDidtapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.tabSwitch addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
    [self.headerViewBillPay.tabSwitch addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
    [self.headerView.vaCopyButton addTarget:self action:@selector(copyButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    MIDPaymentMethod method = self.paymentMethod.method;
    self.instructionUrl = self.result.pdfURL;
    NSString *expireDate = self.result.expiration;
    
    self.headerViewBillPay.vaTextField.text = [self vaNumber];
    
    if (method == MIDPaymentMethodMandiriVA) {
        MIDMandiriBankTransferResult *result = (MIDMandiriBankTransferResult *)self.result;
        self.headerViewBillPay.companyCodeTextField.text = result.code;
        self.headerViewBillPay.expiredTimeLabel.text = [NSString stringWithFormat:@"%@ %@",[VTClassHelper getTranslationFromAppBundleForString:@"Please complete payment before: %@"], expireDate];
        [self.headerViewBillPay.expiredTimeLabel boldSubstring:expireDate];
        self.headerViewBillPay.vaTextField.enabled = NO;
        [self.headerViewBillPay.companyCodeCopyButton addTarget:self action:@selector(copyButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerViewBillPay.vaCopyButton addTarget:self action:@selector(copyButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([self.paymentMethod.title isEqualToString:@"Other ATM Network"]) {
        self.headerViewBillPay.ButtonCopyConstraintsBottomTextField.constant = 0.0f;
        
        if (method == MIDPaymentMethodBNIVA) {
            self.headerViewBillPay.companyCodeTextField.text =@"009 (Bank BNI)";
        } else if(method == MIDPaymentMethodPermataVA) {
            self.headerViewBillPay.companyCodeTextField.text =@"13 (Bank Permata)";
        }
        
        self.headerViewBillPay.expiredTimeLabel.text = [NSString stringWithFormat:@"%@ %@",[VTClassHelper getTranslationFromAppBundleForString:@"Please complete payment before: %@"], expireDate];
        [self.headerViewBillPay.expiredTimeLabel boldSubstring: expireDate];
        self.headerViewBillPay.vaTextField.enabled = NO;
        
        [self.headerViewBillPay.companyCodeCopyButton addTarget:self action:@selector(copyButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerViewBillPay.vaCopyButton addTarget:self action:@selector(copyButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.paymentMethod.paymentID];
    if ([self.paymentMethod.title isEqualToString:@"Other ATM Network"]) {
        filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.info.merchant.preference.otherVAProcessor];
    }
    
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@",self.paymentMethod.paymentID] ofType:@"plist"];
    }
    
    self.headerView.expiredTimeLabel.text = [NSString stringWithFormat:@"%@ %@",[VTClassHelper getTranslationFromAppBundleForString:@"Please complete payment before: %@"], expireDate];
    [self.headerView.expiredTimeLabel boldSubstring: expireDate];
    self.headerView.vaTextField.enabled = NO;
    self.headerView.vaTextField.text = [self vaNumber];
    self.headerView.tutorialTitleLabel.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"%@ step by step"], self.paymentMethod.title];
    
    self.mainInstructions = [VTClassHelper groupedInstructionsFromFilePath:guidePath];
    for (int i=0; i < [self.mainInstructions count]; i++) {
        VTGroupedInstruction *groupedIns = self.mainInstructions[i];
        if (i > 1) {
            if ([self.paymentMethod.title isEqualToString:@"Mandiri"] ||  [self.paymentMethod.title isEqualToString:@"Other ATM Network"]) {
                [self.headerViewBillPay.tabSwitch insertSegmentWithTitle:groupedIns.name atIndex:i animated:NO];
            }
            else {
                [self.headerView.tabSwitch insertSegmentWithTitle:groupedIns.name atIndex:i animated:NO];
            }
            
        }
        
        else {
            if ([self.paymentMethod.title isEqualToString:@"Mandiri"] ||  [self.paymentMethod.title isEqualToString:@"Other ATM Network"]) {
                [self.headerViewBillPay.tabSwitch setTitle:groupedIns.name forSegmentAtIndex:i];
            }
            else {
                [self.headerView.tabSwitch setTitle:groupedIns.name forSegmentAtIndex:i];
            }
            
        }
    }
    self.tableView.tableFooterView = self.footerView;
    [self selectTabAtIndex:0];
    
    self.totalAmountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
    [self.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
}

- (NSString *)vaNumber {
    switch (self.paymentMethod.method) {
        case MIDPaymentMethodPermataVA:
            return ((MIDPermataBankTransferResult *) self.result).vaNumber;
            
        case MIDPaymentMethodMandiriVA:
            return ((MIDMandiriBankTransferResult *) self.result).key;
            
        case MIDPaymentMethodBCAVA:
            return ((MIDBCABankTransferResult *) self.result).vaNumber;
            
        case MIDPaymentMethodBNIVA:
        case MIDPaymentMethodOtherVA:
            return ((MIDBNIBankTransferResult *) self.result).vaNumber;
            
        default:
            return nil;
    }
}

- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.totalAmountBorderedView items:self.info.items];
}

- (void)downloadButtonDidtapped:(id)sender {
    
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:self.instructionUrl];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"Failed to open Instructions"] duration:1.5 containerView:self.view];
            }
        }];
    } else {
        [application openURL:URL];
    }
}

- (void)copyButtonDidTapped:(id)sender {
    if ([self.paymentMethod.title isEqualToString:@"Mandiri"] || [self.paymentMethod.title isEqualToString:@"Other ATM Network"]) {
        
        if ([sender isEqual:self.headerViewBillPay.companyCodeCopyButton]) {
            [[UIPasteboard generalPasteboard] setString:self.headerViewBillPay.companyCodeTextField.text];
            [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self.view];
        }
        else {
            [[UIPasteboard generalPasteboard] setString:self.headerViewBillPay.vaTextField.text];
            [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self.view];
        }
    }
    else {
        [[UIPasteboard generalPasteboard] setString:self.headerView.vaTextField.text];
        [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self.view];
    }
}

- (void)tabChanged:(UISegmentedControl *)sender {
    [self selectTabAtIndex:sender.selectedSegmentIndex];
}

- (void)selectTabAtIndex:(NSInteger)index {
    VTGroupedInstruction *groupedInst = self.mainInstructions[index];
    if ([groupedInst.name containsString:@"ATM"] || [groupedInst.name containsString:@"atm"] ||[groupedInst.name containsString:@"Alto"] || [groupedInst.name containsString:@"ALTO"]) {
        [self.finishPaymentButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Complete Payment at ATM"] forState: UIControlStateNormal];
    }
    else {
        [self.finishPaymentButton setTitle:[NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"payment.finish-button-title-via"],groupedInst.name] forState:UIControlStateNormal];
    }
    self.subInstructions = groupedInst.instructions;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subInstructions.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if ([self.paymentMethod.title isEqualToString:@"Mandiri"]|| [self.paymentMethod.title isEqualToString:@"Other ATM Network"] ) {
            return self.headerViewBillPay;
        }
        else {
            return self.headerView;
        }
        return self.headerView;
    }
    if (indexPath.row == self.subInstructions.count+1) {
        return self.footerView;
    }
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    if(indexPath.row %2 ==0) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }
    [cell setInstruction:self.subInstructions[indexPath.row-1] number:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        if (indexPath.row == 0) {
            if ([self.paymentMethod.title isEqualToString:@"Mandiri"]) {
                return [self.headerViewBillPay.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
            else {
                return [self.headerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
        }
        else {
            static VTGuideCell *cell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
            });
            [cell setInstruction:self.subInstructions[indexPath.row-1] number:indexPath.row];
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
    }
}

- (IBAction)finishPaymentDidtapped:(id)sender {
    NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY: [self.result dictionaryValue]};
    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
