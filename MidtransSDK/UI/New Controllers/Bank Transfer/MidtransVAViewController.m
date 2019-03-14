//
//  MidtransVAViewController.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransVAViewController.h"
#import "MidtransUITextField.h"
#import "MidtransVAHeader.h"
#import "VTClassHelper.h"
#import "SNPPostPaymentVAViewController.h"
#import "VTGuideCell.h"
#import "MidtransUIToast.h"
#import "MidtransUITableAlertViewController.h"
#import "UIViewController+Modal.h"
#import "MIdtransUIBorderedView.h"
#import "MidtransTransactionDetailViewController.h"
#import "MidtransUIThemeManager.h"
#import "MIDConstants.h"
#import "MidtransDeviceHelper.h"

@interface MidtransVAViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraints;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic) MidtransVAHeader *headerView;
@property (nonatomic) NSArray *mainInstructions;
@property (nonatomic) NSArray *subInstructions;
@property (nonatomic,strong) NSMutableArray *currentInstruction;
@property (weak, nonatomic) IBOutlet MIdtransUIBorderedView *totalAmountBorderedView;
@property (nonatomic) NSArray *otherBankListATMBersama;
@property (nonatomic) NSArray *otherBankListPrima;
@property (nonatomic) NSArray *otherBankListAlto;
@property (nonatomic) BOOL isShowInstruction;
@property (nonatomic) CGFloat currentTableViewHieght;
@property (nonatomic) MidtransVAType paymentType;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@end

@implementation MidtransVAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isShowInstruction = 0;
    self.currentInstruction = [NSMutableArray new];
    self.title = self.paymentMethod.title;
    id paymentID = self.paymentMethod.paymentID;
    self.totalAmountLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    [self.payButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"va.pay-button"] forState:UIControlStateNormal];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransVAHeader" bundle:VTBundle] forCellReuseIdentifier:@"MidtransVAHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    
    self.amountLabel.text = [self.info.items formattedPriceAmount];
    self.orderIdLabel.text = self.info.transaction.orderID;
    
    self.headerView = [self.tableView dequeueReusableCellWithIdentifier:@"MidtransVAHeader"];
    [self.headerView.tabSwitch addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
    self.headerView.emailTextField.text = self.info.customer.email;
    self.headerView.emailTextField.placeholder = [VTClassHelper getTranslationFromAppBundleForString:@"payment.email-placeholder"];
    self.headerView.descLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"payment.email-note"];
    self.headerView.tutorialTitleLabel.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"%@ step by step"], self.paymentMethod.title];
    [self.headerView.reloadButton addTarget:self action:@selector(reloadInstruction) forControlEvents:UIControlEventTouchUpInside];
    [self addNavigationToTextFields:@[self.headerView.emailTextField]];
    self.headerView.keySMSviewConstraints.constant = 0.0f;
    if ([paymentID isEqualToString:MIDTRANS_PAYMENT_BNI_VA] || [paymentID isEqualToString:MIDTRANS_PAYMENT_BCA_VA]) {
        self.headerView.keySMSviewConstraints.constant = 0.0f;
        self.headerView.keyView.hidden = YES;
    }
    
    MIDPaymentMethod method = self.paymentMethod.method;
    if (method == MIDPaymentMethodOtherVA) {
        if (method == MIDPaymentMethodBNIVA ||
            method == MIDPaymentMethodPermataVA) {
            self.headerView.keySMSviewConstraints.constant = 0.0f;
            self.headerView.keyView.hidden = YES;
        }
    }
    self.headerView.smsChargeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"SMS Charges may be applied for this payment method"];
    [self.headerView.expandBankListButton addTarget:self action:@selector(displayBankList) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView updateConstraints];
    [self.headerView layoutIfNeeded];
    
    NSString *otherVAProcessor = self.info.merchant.preference.otherVAProcessor;
    NSString* filenameByLanguage;
    if (method == MIDPaymentMethodOtherVA) {
        if (otherVAProcessor.length > 0) {
            filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", otherVAProcessor];
        } else {
            filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", paymentID];
        }
        
    } else {
        filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", paymentID];
    }
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_%@", paymentID] ofType:@"plist"];
    }
    self.mainInstructions = [VTClassHelper groupedInstructionsFromFilePath:guidePath];
    for (int i=0; i < [self.mainInstructions count]; i++) {
        VTGroupedInstruction *groupedIns = self.mainInstructions[i];
        if (i > 1) {
            [self.headerView.tabSwitch insertSegmentWithTitle:groupedIns.name atIndex:i animated:NO];
        } else {
            [self.headerView.tabSwitch setTitle:groupedIns.name forSegmentAtIndex:i];
        }
    }
    [self selectTabAtIndex:0];
    
    if ([paymentID isEqualToString:MIDTRANS_PAYMENT_BCA_VA]) {
        self.paymentType = VTVATypeBCA;
    }
    else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_ECHANNEL]) {
        self.paymentType = VTVATypeMandiri;
    }
    else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA]) {
        self.paymentType = VTVATypePermata;
    }
    else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_OTHER_VA]) {
        if (otherVAProcessor.length > 0) {
            if ([otherVAProcessor isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA]) {
                self.paymentType = VTVATypePermata;
            }
            else if ([otherVAProcessor isEqualToString:MIDTRANS_PAYMENT_BNI_VA]) {
                self.paymentType = VTVATypeBNI;
            } else {
                self.paymentType = VTVATypeOther;
            }
            
        } else {
            self.paymentType = VTVATypeOther;
        }
        
    }
    else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_ALL_VA]) {
        self.paymentType = VTVATypeOther;
    }
    else if ([paymentID isEqualToString:MIDTRANS_PAYMENT_BNI_VA]) {
        self.paymentType = VTVATypeBNI;
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VTTapableLabelDidTapLink object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [[UIPasteboard generalPasteboard] setString:note.object];
        [MidtransUIToast createToast:[VTClassHelper getTranslationFromAppBundleForString:@"toast.copy-text"] duration:1.5 containerView:self.view];
    }];
    [self.totalAmountBorderedView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalAmountBorderedViewTapped:)]];
    self.amountLabel.textColor = [[MidtransUIThemeManager shared] themeColor];
    self.currentTableViewHieght = CGRectGetHeight(self.tableView.frame);
}
- (void)reloadInstruction {
    if (!self.isShowInstruction) {
        self.subInstructions = self.currentInstruction;
        [self.tableView reloadData];
        self.isShowInstruction = 1;
    } else {
        self.subInstructions = @[];
        [self.tableView reloadData];
        self.isShowInstruction = 0;
    }
}
- (void) totalAmountBorderedViewTapped:(id) sender {
    MidtransTransactionDetailViewController *transactionViewController = [[MidtransTransactionDetailViewController alloc] initWithNibName:@"MidtransTransactionDetailViewController" bundle:VTBundle];
    [transactionViewController presentAtPositionOfView:self.totalAmountBorderedView items:self.info.items];
}
-(void) displayBankList {
    
    MTOtherBankType type;
    if (self.headerView.tabSwitch.selectedSegmentIndex == 0) {
        type = MTOtherBankTypeATMBersama;
    } else if (self.headerView.tabSwitch.selectedSegmentIndex == 1) {
        if (self.paymentMethod.method == MIDPaymentMethodPermataVA) {
            type = MTOtherBankTypeAlto;
        } else {
            type = MTOtherBankTypePrima;
        }
    } else {
        type = MTOtherBankTypeAlto;
    }
    MidtransUITableAlertViewController* alert = [[MidtransUITableAlertViewController alloc] initWithType:type];
    
    [self.navigationController presentCustomViewController:alert
                                          onViewController:self.navigationController
                                                completion:nil];
}

- (void)handleError:(NSError * _Nullable)error result:(MIDPaymentResult * _Nullable)result {
    [self hideLoading];
    if (error) {
        [self handleTransactionError:error];
    } else {
        SNPPostPaymentVAViewController *postPaymentVAController = [[SNPPostPaymentVAViewController alloc] initWithPaymentMethod:self.paymentMethod paymentResult:result];
        [self.navigationController pushViewController:postPaymentVAController animated:YES];
    }
}

- (IBAction)payPressed:(id)sender {
    NSString *email = self.headerView.emailTextField.text;
    
    [self showLoadingWithText:nil];
    
    switch (self.paymentMethod.method) {
        case MIDPaymentMethodBNIVA: {
            [MIDBankTransferCharge bniWithToken:self.snapToken
                                           name:nil
                                          email:email
                                          phone:nil
                                     completion:^(MIDBNIBankTransferResult * _Nullable result, NSError * _Nullable error)
             {
                 [self handleError:error result:result];
             }];
            break;
        }
        case MIDPaymentMethodBCAVA: {
            [MIDBankTransferCharge bcaWithToken:self.snapToken
                                           name:nil
                                          email:email
                                          phone:nil
                                     completion:^(MIDBCABankTransferResult * _Nullable result, NSError * _Nullable error)
             {
                 [self handleError:error result:result];
             }];
            break;
        }
        case MIDPaymentMethodPermataVA: {
            [MIDBankTransferCharge permataWithToken:self.snapToken
                                               name:nil
                                              email:email
                                              phone:nil
                                         completion:^(MIDPermataBankTransferResult * _Nullable result, NSError * _Nullable error)
             {
                 [self handleError:error result:result];
             }];
            break;
        }
        case MIDPaymentMethodMandiriVA: {
            [MIDBankTransferCharge mandiriWithToken:self.snapToken
                                               name:nil
                                              email:email
                                              phone:nil
                                         completion:^(MIDMandiriBankTransferResult * _Nullable result, NSError * _Nullable error)
             {
                 [self handleError:error result:result];
             }];
            break;
        }
        case MIDPaymentMethodOtherVA: {
            [MIDBankTransferCharge otherBankWithToken:self.snapToken
                                                 name:nil
                                                email:email
                                                phone:nil
                                           completion:^(id _Nullable result, NSError * _Nullable error)
             {
                 MIDPermataBankTransferResult *permataResult = [[MIDPermataBankTransferResult alloc] initWithDictionary:result];
                 if (permataResult.vaNumber) {
                     [self handleError:error result:permataResult];
                 } else {
                     MIDBNIBankTransferResult *bniResult = [[MIDBNIBankTransferResult alloc] initWithDictionary:result];
                     [self handleError:error result:bniResult];
                 }
             }];
            break;
        }
        default:
            break;
    }
}
- (void)tabChanged:(UISegmentedControl *)sender {
    [self selectTabAtIndex:sender.selectedSegmentIndex];
}

- (void)selectTabAtIndex:(NSInteger)index {
    VTGroupedInstruction *groupedInst = self.mainInstructions[index];
    MIDPaymentMethod method = self.paymentMethod.method;
    
    if (index == 0) {
        self.headerView.keySMSviewConstraints.constant = 0.0f;
        self.headerView.keyView.hidden =YES;
        self.headerView.otherAtmIconsImageView.image = [UIImage imageNamed:@"bersama_preview" inBundle:VTBundle compatibleWithTraitCollection:nil];
        self.headerView.payNoticeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Pay through ‘all bank ATMs with ATM Bersama logo’"];
        [self.headerView.expandBankListButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Total 83 registered banks"] forState:UIControlStateNormal];
    } else if (index == 1) {
        if (method == MIDPaymentMethodBNIVA ||
            method == MIDPaymentMethodBCAVA) {
            self.headerView.keySMSviewConstraints.constant = 40.0f;
            self.headerView.keyView.hidden = YES;
        }
        self.headerView.keyView.hidden = NO;
        if (method == MIDPaymentMethodPermataVA) {
            self.headerView.otherAtmIconsImageView.image = [UIImage imageNamed:@"alto_preview" inBundle:VTBundle compatibleWithTraitCollection:nil];
            self.headerView.payNoticeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Pay through ‘all bank ATMs with Alto logo’"];
            [self.headerView.expandBankListButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Total 19 registered banks"] forState:UIControlStateNormal];
        } else {
            
            self.headerView.otherAtmIconsImageView.image = [UIImage imageNamed:@"prima_preview" inBundle:VTBundle compatibleWithTraitCollection:nil];
            self.headerView.payNoticeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Pay through ‘all bank ATMs with Prima logo’"];
            [self.headerView.expandBankListButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Total 64 registered banks"] forState:UIControlStateNormal];
        }
    } else {
        self.headerView.keySMSviewConstraints.constant = 0.0f;
        self.headerView.keyView.hidden = YES;
        self.headerView.otherAtmIconsImageView.image = [UIImage imageNamed:@"alto_preview" inBundle:VTBundle compatibleWithTraitCollection:nil];
        self.headerView.payNoticeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Pay through ‘all bank ATMs with Alto logo’"];
        [self.headerView.expandBankListButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Total 19 registered banks"] forState:UIControlStateNormal];
    }
    
    if (method == MIDPaymentMethodOtherVA) {
        if (method == MIDPaymentMethodPermataVA && index == 1) {
            self.headerView.otherAtmIconsHeightLayoutConstraint.constant = 24.0f;
            self.headerView.payNoticeLabelHeightConstraint.constant = 84.0f;
            self.headerView.expandListButtonHeightConstraint.constant = 0.0f;
        }
        else if (method == MIDPaymentMethodBNIVA && index == 1) {
            self.headerView.otherAtmIconsHeightLayoutConstraint.constant = 24.0f;
            self.headerView.payNoticeLabelHeightConstraint.constant = 84.0f;
            self.headerView.expandListButtonHeightConstraint.constant = 0.0f;
        }
        else {
            self.headerView.otherAtmIconsHeightLayoutConstraint.constant = 24.0f;
            self.headerView.payNoticeLabelHeightConstraint.constant = 84.0f;
            self.headerView.expandListButtonHeightConstraint.constant = 24.0f;
        }
    } else if (method == MIDPaymentMethodPermataVA && index == 1) {
        self.headerView.otherAtmIconsHeightLayoutConstraint.constant = 24.0f;
        self.headerView.payNoticeLabelHeightConstraint.constant = 84.0f;
        self.headerView.expandListButtonHeightConstraint.constant = 24.0f;
    } else {
        self.headerView.otherAtmIconsHeightLayoutConstraint.constant = 0.0f;
        self.headerView.payNoticeLabelHeightConstraint.constant = 0.0f;
        self.headerView.expandListButtonHeightConstraint.constant = 0.0f;
        [self.headerView.expandBankListButton setTitle:nil forState:UIControlStateNormal];
    }
    self.subInstructions = groupedInst.instructions;
    self.currentInstruction = [NSMutableArray arrayWithArray:self.subInstructions];
    self.subInstructions = @[];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subInstructions.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.headerView;
    }
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    [cell setInstruction:self.subInstructions[indexPath.row-1] number:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    else {
        if (indexPath.row == 0) {
            return [self.headerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
        else {
            static VTGuideCell *cell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
            });
            if(indexPath.row %2 ==0) {
                cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
            }
            [cell setInstruction:self.subInstructions[indexPath.row-1] number:indexPath.row];
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
    }
}

@end
