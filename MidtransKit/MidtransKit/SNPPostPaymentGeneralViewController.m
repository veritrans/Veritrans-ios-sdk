//
//  SNPPostPaymentGeneralViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 6/9/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "SNPPostPaymentGeneralViewController.h"
#import "SNPPostPaymentGeneralView.h"
#import "SNPPostPaymentHeader.h"
#import "MidtransUIToast.h"
#import "VTClassHelper.h"
#import "VTGuideCell.h"
#import "UILabel+Boldify.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@interface SNPPostPaymentGeneralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet SNPPostPaymentGeneralView *view;
@property (nonatomic,strong) NSArray *instrunctions;
@property (nonatomic) SNPPostPaymentHeader *headerView;
@end

@implementation SNPPostPaymentGeneralViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self showBackButton:NO];
    self.view.tableView.estimatedRowHeight = 60;
    self.view.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view.tableView registerNib:[UINib nibWithNibName:@"SNPPostPaymentHeader" bundle:VTBundle] forCellReuseIdentifier:@"SNPPostPaymentHeader"];
    [self.view.tableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    self.headerView = [self.view.tableView dequeueReusableCellWithIdentifier:@"SNPPostPaymentHeader"];
    self.headerView.topTextLabel.text = @"Payment Code";
    if ([self.title isEqualToString:@"Kioson"]) {
        self.headerView.expiredTimeLabel.text = self.transactionResult.kiosonExpireTime;
    }
    [self.headerView updateFocusIfNeeded];
    [self.headerView.tabSwitch removeFromSuperview];
    [self.headerView.tutorialTitleLabel removeFromSuperview];
    self.view.tableView.tableHeaderView = self.headerView;
    self.headerView.vaTextField.text = self.transactionResult.indomaretPaymentCode;
    self.title = [self.paymentMethod.title capitalizedString];
    self.instrunctions = [VTClassHelper instructionsFromFilePath:[VTBundle pathForResource:self.paymentMethod.internalBaseClassIdentifier ofType:@"plist"]];
    [self.headerView.vaCopyButton addTarget:self action:@selector(copyButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instrunctions.count;
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
    [MidtransUIToast createToast:UILocalizedString(@"toast.copy-text",nil) duration:1.5 containerView:self.view];
}
- (IBAction)finishPaymentDidtapped:(id)sender {
    
}


@end
