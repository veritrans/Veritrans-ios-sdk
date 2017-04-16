//
//  SNPPostPaymentVAViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 4/12/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPostPaymentVAViewController.h"
#import "SNPPostPaymentHeader.h"
#import "VTClassHelper.h"
#import "SNPPostPaymentFooter.h"
#import "MidtransUIToast.h"
#import "VTGuideCell.h"
#import "UILabel+Boldify.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@interface SNPPostPaymentVAViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *mainInstructions;
@property (nonatomic) NSArray *subInstructions;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic,strong) NSString *instructionUrl;
@property (nonatomic) SNPPostPaymentHeader *headerView;
@property (nonatomic) SNPPostPaymentFooter *footerView;
@end

@implementation SNPPostPaymentVAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.paymentMethod.title;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SNPPostPaymentHeader" bundle:VTBundle] forCellReuseIdentifier:@"SNPPostPaymentHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SNPPostPaymentFooter" bundle:VTBundle] forCellReuseIdentifier:@"SNPPostPaymentFooter"];
     self.totalAmountLabel.text = [self.token.itemDetails formattedPriceAmount];
    [self.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    
    
    self.headerView = [self.tableView dequeueReusableCellWithIdentifier:@"SNPPostPaymentHeader"];
    self.footerView = [self.tableView dequeueReusableCellWithIdentifier:@"SNPPostPaymentFooter"];
    [self.footerView.downloadInstructionButton addTarget:self action:@selector(downloadButtonDidtapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.tabSwitch addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
    [self.headerView.vaCopyButton addTarget:self action:@selector(copyButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    NSString *vaNumber;
    NSString *expireDate;
    self.instructionUrl = [self.transactionResult.additionalData objectForKey:@"pdf_url"];
    if ([self.paymentMethod.title isEqualToString:@"BCA"]) {
        vaNumber = [self.transactionResult.additionalData objectForKey:@"bca_va_number"];
        expireDate = [self.transactionResult.additionalData objectForKey:@"bca_expiration" ];
    }
    else if ([self.paymentMethod.title isEqualToString:@"Permata"]) {
        vaNumber = [self.transactionResult.additionalData objectForKey:@"permata_va_number"];
        expireDate = [self.transactionResult.additionalData objectForKey:@"permata_expiration" ];
    }
   
    
    NSString *guidePath = [VTBundle pathForResource:self.paymentMethod.internalBaseClassIdentifier ofType:@"plist"];
    if ([self.paymentMethod.title isEqualToString:@"Other Bank"]) {
        guidePath = [VTBundle pathForResource:@"all_va" ofType:@"plist"];
        vaNumber = [self.transactionResult.additionalData objectForKey:@"permata_va_number"];
        expireDate = [self.transactionResult.additionalData objectForKey:@"permata_expiration" ];
    }
    self.headerView.expiredTimeLabel.text = [NSString stringWithFormat:@"Please complete payment before: %@",expireDate];
    [self.headerView.expiredTimeLabel boldSubstring:expireDate];
    self.headerView.vaTextField.enabled = NO;
    self.headerView.vaTextField.text = vaNumber;
    self.headerView.tutorialTitleLabel.text = [NSString stringWithFormat:@"%@ transfer step by step", self.title];
    
    self.mainInstructions = [VTClassHelper groupedInstructionsFromFilePath:guidePath];
    for (int i=0; i<[self.mainInstructions count]; i++) {
        VTGroupedInstruction *groupedIns = self.mainInstructions[i];
        if (i>1) {
            [self.headerView.tabSwitch insertSegmentWithTitle:groupedIns.name atIndex:i animated:NO];
        } else {
            [self.headerView.tabSwitch setTitle:groupedIns.name forSegmentAtIndex:i];
        }
    }
    self.tableView.tableFooterView = self.footerView;
    [self selectTabAtIndex:0];

    
    // Do any additional setup after loading the view from its nib.
}
- (void)downloadButtonDidtapped:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:self.instructionUrl];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (!success) {
           [MidtransUIToast createToast:@"Failed to open Instructions" duration:1.5 containerView:self.view];
        }
    }];
}
- (void)copyButtonDidTapped:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.headerView.vaTextField.text];
    [MidtransUIToast createToast:UILocalizedString(@"toast.copy-text",nil) duration:1.5 containerView:self.view];
}
- (void)tabChanged:(UISegmentedControl *)sender {
    [self selectTabAtIndex:sender.selectedSegmentIndex];
}

- (void)selectTabAtIndex:(NSInteger)index {
    VTGroupedInstruction *groupedInst = self.mainInstructions[index];
    self.subInstructions = groupedInst.instructions;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subInstructions.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.headerView;
    }
    if (indexPath.row == self.subInstructions.count+1) {
        return self.footerView;
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
- (IBAction)finishPaymentDidtapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
