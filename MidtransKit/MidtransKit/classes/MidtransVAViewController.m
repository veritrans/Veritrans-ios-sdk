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
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidtransUIToast.h"
#import "MidtransUITableAlertViewController.h"
#import "UIViewController+Modal.h"

@interface MidtransVAViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic) MidtransVAHeader *headerView;
@property (nonatomic) NSArray *mainInstructions;
@property (nonatomic) NSArray *subInstructions;
@property (nonatomic) NSArray *otherBankListATMBersama;
@property (nonatomic) NSArray *otherBankListPrima;
@property (nonatomic) NSArray *otherBankListAlto;

@property (nonatomic) MidtransVAType paymentType;
@end

@implementation MidtransVAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.paymentMethod.title;
    id paymentID = self.paymentMethod.internalBaseClassIdentifier;
    self.totalAmountLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"total.amount"];
    [self.payButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"va.pay-button"] forState:UIControlStateNormal];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MidtransVAHeader" bundle:VTBundle] forCellReuseIdentifier:@"MidtransVAHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    
    self.amountLabel.text = [self.token.itemDetails formattedPriceAmount];
    
    self.headerView = [self.tableView dequeueReusableCellWithIdentifier:@"MidtransVAHeader"];
    [self.headerView.tabSwitch addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
    self.headerView.emailTextField.text = self.token.customerDetails.email;
    self.headerView.emailTextField.placeholder = [VTClassHelper getTranslationFromAppBundleForString:@"payment.email-placeholder"];
    self.headerView.descLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"payment.email-note"];
    self.headerView.tutorialTitleLabel.text = [NSString stringWithFormat:[VTClassHelper getTranslationFromAppBundleForString:@"%@ step by step"], self.paymentMethod.title];
    [self addNavigationToTextFields:@[self.headerView.emailTextField]];
    self.headerView.keySMSviewConstraints.constant = 0.0f;
    if ([paymentID isEqualToString:MIDTRANS_PAYMENT_BNI_VA] || [paymentID isEqualToString:MIDTRANS_PAYMENT_BCA_VA]) {
        self.headerView.keySMSviewConstraints.constant = 0.0f;
        self.headerView.keyView.hidden = YES;
    }
    self.headerView.smsChargeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"SMS Charges may be applied for this payment method"];
    [self.headerView.expandBankListButton addTarget:self action:@selector(displayBankList) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView updateConstraints];
    [self.headerView layoutIfNeeded];
    
    [self loadOtherBankList];
    NSString* filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", self.paymentMethod.internalBaseClassIdentifier];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if ([self.paymentMethod.title isEqualToString:[VTClassHelper getTranslationFromAppBundleForString:@"Other ATM Network"]]) {
        filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_%@", @"other_va"];
        guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
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
        self.paymentType = VTVATypeOther;
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
}

-(void) displayBankList {
    
    NSArray* bankList = @[];
    NSString* title = @"";
    if (self.headerView.tabSwitch.selectedSegmentIndex == 0) {
        bankList = self.otherBankListATMBersama;
        title = [VTClassHelper getTranslationFromAppBundleForString:@"Banks registered with ATM Bersama"];
    } else if (self.headerView.tabSwitch.selectedSegmentIndex == 1) {
        if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA]) {
            bankList = self.otherBankListAlto;
            title = [VTClassHelper getTranslationFromAppBundleForString:@"Banks registered with Alto"];
        } else {
            bankList = self.otherBankListPrima;
            title = [VTClassHelper getTranslationFromAppBundleForString:@"Banks registered with Prima"];
        }
    } else {
        bankList = self.otherBankListAlto;
        title = [VTClassHelper getTranslationFromAppBundleForString:@"Banks registered with Alto"];
    }
    MidtransUITableAlertViewController* alert = [[MidtransUITableAlertViewController alloc] initWithTitle:title closeButtonTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Close"] withList:bankList];
    
    [self.navigationController presentCustomViewController:alert
                                          onViewController:self.navigationController
                                                completion:nil];
}

- (IBAction)payPressed:(id)sender {
    MidtransPaymentBankTransfer *paymentDetails = [[MidtransPaymentBankTransfer alloc] initWithBankTransferType:self.paymentType
                                                                                                          email:self.headerView.emailTextField.text];
    self.token.customerDetails.email = self.headerView.emailTextField.text;
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails
                                                                                     token:self.token];
    
    [self showLoadingWithText:nil];
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        if (error) {
            [self handleTransactionError:error];
        } else {
            SNPPostPaymentVAViewController *postPaymentVAController = [[SNPPostPaymentVAViewController alloc] initWithNibName:@"SNPPostPaymentVAViewController" bundle:VTBundle];
            
            postPaymentVAController.token = self.token;
            postPaymentVAController.paymentMethod = self.paymentMethod;
            postPaymentVAController.transactionDetail = transaction;
            postPaymentVAController.transactionResult = result;
            [self.navigationController pushViewController:postPaymentVAController animated:YES];
        }
    }];
}

- (void)tabChanged:(UISegmentedControl *)sender {
    [self selectTabAtIndex:sender.selectedSegmentIndex];
}

- (void)selectTabAtIndex:(NSInteger)index {
    VTGroupedInstruction *groupedInst = self.mainInstructions[index];
    
    if (index == 0) {
        self.headerView.keySMSviewConstraints.constant = 0.0f;
        self.headerView.keyView.hidden =YES;
        self.headerView.otherAtmIconsImageView.image = [UIImage imageNamed:@"bersama_preview" inBundle:VTBundle compatibleWithTraitCollection:nil];
        self.headerView.payNoticeLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Pay through ‘all bank ATMs with ATM Bersama logo’"];
        [self.headerView.expandBankListButton setTitle:[VTClassHelper getTranslationFromAppBundleForString:@"Total 83 registered banks"] forState:UIControlStateNormal];
    } else if (index == 1) {
        if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BNI_VA] || [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_VA]) {
            self.headerView.keySMSviewConstraints.constant = 40.0f;
            self.headerView.keyView.hidden = YES;
        }
        self.headerView.keyView.hidden = NO;
        if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA]) {
            
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
    
    if ( [self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_OTHER_VA]) {
        self.headerView.otherAtmIconsHeightLayoutConstraint.constant = 24.0f;
        self.headerView.payNoticeLabelHeightConstraint.constant = 84.0f;
        self.headerView.expandListButtonHeightConstraint.constant = 24.0f;
    } else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA] && index == 1) {
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
            [cell setInstruction:self.subInstructions[indexPath.row-1] number:indexPath.row];
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
    }
}

-(void) loadOtherBankList {
    
    self.otherBankListATMBersama = @[@"Bank Aceh",
                                     @"Bank Agroniaga",
                                     @"Bank Andara",
                                     @"Bank ANZ",
                                     @"Bank Artos Indonesia",
                                     @"Bank Bengkulu",
                                     @"Bank BJB",
                                     @"Bank BJB Syariah",
                                     @"Bank Bukopin",
                                     @"Bank Capital",
                                     @"Bank CIMB Niaga",
                                     @"Bank Commonwealth",
                                     @"Bank Danamon",
                                     @"Bank DBS",
                                     @"Bank Dinar",
                                     @"Bank DKI",
                                     @"Bank Ekonomi",
                                     @"Bank Ganesha",
                                     @"Bank HSBC",
                                     @"Bank ICBC",
                                     @"Bank Ina Perdana",
                                     @"Bank Index",
                                     @"Bank J Trust",
                                     @"Bank Jambi",
                                     @"Bank Jateng",
                                     @"Bank Jatim",
                                     @"Bank Kalbar",
                                     @"Bank Kalsel",
                                     @"Bank Kaltim",
                                     @"Bank Kesejahteraan",
                                     @"Bank Lampung",
                                     @"Bank Maluku",
                                     @"Bank Mandiri",
                                     @"Bank Mayapada Internasional",
                                     @"Bank Maybank Indonesia",
                                     @"Bank Mayora",
                                     @"Bank Mega Syariah",
                                     @"Bank Mega",
                                     @"Bank Mestika",
                                     @"Bank MNC Internasional",
                                     @"Bank Muamalat",
                                     @"Bank Nagari",
                                     @"Bank Negara Indonesia (BNI)",
                                     @"Bank NTB",
                                     @"Bank NTT",
                                     @"Bank Nusantara Parahyangan (BNP)",
                                     @"Bank of China",
                                     @"Bank of India Indonesia",
                                     @"Bank Panin Syariah",
                                     @"Bank Panin",
                                     @"Bank Papua",
                                     @"Bank Permata",
                                     @"Bank Pundi Indonesia",
                                     @"Bank QNB Kesawan",
                                     @"Bank Rakyat Indonesia (BRI)",
                                     @"Bank Riau Kepri",
                                     @"Bank Saudara",
                                     @"Bank Sinarmas",
                                     @"Bank Sulselbar",
                                     @"Bank Sulteng",
                                     @"Bank Sultra",
                                     @"Bank Sulut",
                                     @"Bank Sumsel Babel",
                                     @"Bank Sumut",
                                     @"Bank Syariah Mandiri",
                                     @"Bank Tabungan Negara (BTN)",
                                     @"Bank Tabungan Pensiunan (BTPN)",
                                     @"Bank Woori Saudara (BWS)",
                                     @"BPD Bali",
                                     @"BPD DIY",
                                     @"BPD Kalteng",
                                     @"BPR Bank Supra",
                                     @"BPR Eka Bumi Artha",
                                     @"BPR KS",
                                     @"BPR Semoga Jaya Artha",
                                     @"BRI Syariah",
                                     @"Citibank",
                                     @"ICB Bumiputera",
                                     @"Nobu Bank",
                                     @"OCBC NISP",
                                     @"Rabobank",
                                     @"Standard Chartered",
                                     @"UOB Indonesia"];
    self.otherBankListPrima = @[@"Bank Aceh Syariah",
                                @"Bank Agris",
                                @"Bank ANDA",
                                @"Bank ANZ",
                                @"Bank Artha Graha",
                                @"Bank Banten",
                                @"Bank BCA",
                                @"Bank BCA Syariah",
                                @"Bank BJB",
                                @"Bank BJB Syariah",
                                @"Bank BNI",
                                @"Bank BNP",
                                @"Bank BPD DIY",
                                @"Bank BRI",
                                @"Bank BRI Syariah",
                                @"Bank BTN",
                                @"Bank BTPN",
                                @"Bank BTPN Syariah",
                                @"Bank Bukopin",
                                @"Bank Bumi Arta",
                                @"Bank CIMB Niaga",
                                @"Bank Commonwealth",
                                @"Bank CTBC Indonesia",
                                @"Bank Danamon Indonesia",
                                @"Bank DKI",
                                @"Bank Ekonomi",
                                @"Bank Jasa Jakarta",
                                @"Bank Jateng",
                                @"Bank Jatim",
                                @"Bank JTrust Indonesia",
                                @"Bank Kalbar",
                                @"Bank Kaltim",
                                @"Bank KEB Hana Indonesia",
                                @"Bank Mandiri",
                                @"Bank Maspion",
                                @"Bank Mayapada",
                                @"Bank Maybank Indonesia",
                                @"Bank Mega Syariah",
                                @"Bank Mega",
                                @"Bank MNC",
                                @"Bank Muamalat",
                                @"Bank Multiarta Sentosa",
                                @"Bank Nagari",
                                @"Bank National Nobu",
                                @"Bank OCBC NISP",
                                @"Bank of Tokyo — Mitsubishi",
                                @"Bank Panin",
                                @"Bank Papua",
                                @"Bank Permata",
                                @"Bank Rabobank",
                                @"Bank Riaukepri",
                                @"Bank Royal",
                                @"Bank Sahabat Sampoerna",
                                @"Bank SBI Indonesia",
                                @"Bank Sinarmas",
                                @"Bank Sulselbar",
                                @"Bank Sumselbabel",
                                @"Bank Syariah Bukopin",
                                @"Bank Syariah Mandiri",
                                @"Bank UOB Indonesia",
                                @"Bank Victoria",
                                @"Bank Victoria Syariah",
                                @"Bank Windu",
                                @"Bank Woori Saudara"];
    self.otherBankListAlto = @[@"Bank Artha Graha",
                               @"Bank CNB",
                               @"Bank Danamon",
                               @"Bank DBS",
                               @"Bank Harda Internasional (BHI)",
                               @"Bank KEB Hana Indonesia",
                               @"Bank Kesejahteraan",
                               @"Bank Maybank Indonesia",
                               @"Bank Nusantara Parahyangan (BNP)",
                               @"Bank Panin",
                               @"Bank Permata",
                               @"Bank Prima Master",
                               @"Bank SBI Indonesia",
                               @"Bank Sinarmas",
                               @"Bank Tabungan Negara (BTN)",
                               @"BPR Eka Bumi Artha",
                               @"BPR KS",
                               @"Citibank",
                               @"KSP Intidana"];
}
@end
