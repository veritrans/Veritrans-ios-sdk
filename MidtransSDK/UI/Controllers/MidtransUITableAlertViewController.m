//
//  MidtransTableAlertViewController.m
//  MidtransKit
//
//  Created by Tommy.Yohanes on 9/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUITableAlertViewController.h"
#import "VTClassHelper.h"
#import "UIViewController+Modal.h"

@interface MidtransUITableAlertViewController ()
@property (weak, nonatomic) IBOutlet UILabel *listTitle;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic) MTOtherBankType type;
@property (nonatomic) NSArray* list;
@property (nonatomic) NSArray *otherBankListATMBersama;
@property (nonatomic) NSArray *otherBankListPrima;
@property (nonatomic) NSArray *otherBankListAlto;
@end

@implementation MidtransUITableAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadOtherBankList];
    NSArray* bankList = @[];
    NSString* title = @"";
    if (self.type == MTOtherBankTypeATMBersama) {
        bankList = self.otherBankListATMBersama;
        title = [VTClassHelper getTranslationFromAppBundleForString:@"Banks registered with ATM Bersama"];
    } else if (self.type == MTOtherBankTypePrima) {
        bankList = self.otherBankListPrima;
        title = [VTClassHelper getTranslationFromAppBundleForString:@"Banks registered with Prima"];
    } else {
        bankList = self.otherBankListAlto;
        title = [VTClassHelper getTranslationFromAppBundleForString:@"Banks registered with Alto"];
    }
    self.listTitle.text = title;
    [self.closeButton setTitle:@"OK" forState:UIControlStateNormal];
    self.list = bankList;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CABasicAnimation *scale1 = [CABasicAnimation animation];
    scale1.keyPath = @"transform.scale";
    scale1.toValue = @0.95;
    scale1.fromValue = @1.05;
    scale1.duration = 0.1;
    scale1.beginTime = 0.0;
    
    CABasicAnimation *scale2 = [CABasicAnimation animation];
    scale2.keyPath = @"transform.scale";
    scale2.toValue = @1;
    scale2.fromValue = @0.95;
    scale2.duration = 0.09;
    scale2.beginTime = 0.1;
    
    CABasicAnimation *fadeIn = [CABasicAnimation animation];
    fadeIn.keyPath = @"opacity";
    fadeIn.toValue = @1.0;
    fadeIn.fromValue = @0.5;
    fadeIn.duration = 0.8;
    fadeIn.beginTime = 0.0;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.19;
    animationGroup.animations = @[scale1, scale2, fadeIn];
    [self.containerView.layer addAnimation:animationGroup forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWithType:(MTOtherBankType)type {
    self = [super initWithNibName:@"MidtransUITableAlertViewController" bundle:VTBundle];
    if (self) {
        self.type = type;
        
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld.\t%@", indexPath.row+1, self.list[indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:13];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.backgroundColor = indexPath.row % 2 ? [UIColor colorWithWhite:1.0f alpha:1] : [UIColor colorWithWhite:0.95f alpha:1];
    return cell;
}
- (IBAction)didSelectCloseButton:(id)sender {
    [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissCustomViewController:nil];
    });
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
