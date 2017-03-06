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
#import "VTGuideCell.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface MidtransVAViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic) MidtransVAHeader *headerView;
@property (nonatomic) NSArray *mainInstructions;
@property (nonatomic) NSArray *subInstructions;
@property (nonatomic) MidtransVAType paymentType;
@end

@implementation MidtransVAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.paymentMethod.title;
    
    [self.payButton setTitle:UILocalizedString(@"va.pay-button", nil) forState:UIControlStateNormal];
    
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
    self.headerView.tutorialTitleLabel.text = [NSString stringWithFormat:@"%@ transfer step by step", self.title];
    
    NSString *guidePath = [VTBundle pathForResource:self.paymentMethod.internalBaseClassIdentifier ofType:@"plist"];
    if ([self.paymentMethod.title isEqualToString:@"Other Bank"]) {
        guidePath = [VTBundle pathForResource:@"all_va" ofType:@"plist"];
    }
    self.mainInstructions = [VTClassHelper groupedInstructionsFromFilePath:guidePath];
    for (int i=0; i<[self.mainInstructions count]; i++) {
        VTGroupedInstruction *groupedIns = self.mainInstructions[i];
        if (i>1) {
            [self.headerView.tabSwitch insertSegmentWithTitle:groupedIns.name atIndex:i animated:NO];
        } else {
            [self.headerView.tabSwitch setTitle:groupedIns.name forSegmentAtIndex:i];
        }
    }
    [self selectTabAtIndex:0];
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_BCA_VA]) {
        self.paymentType = VTVATypeBCA;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_ECHANNEL]) {
        self.paymentType = VTVATypeMandiri;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_PERMATA_VA]) {
        self.paymentType = VTVATypePermata;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_OTHER_VA]) {
        self.paymentType = VTVATypeOther;
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:MIDTRANS_PAYMENT_ALL_VA]) {
        self.paymentType = VTVATypeOther;
    }
}

- (IBAction)payPressed:(id)sender {
    MidtransPaymentBankTransfer *paymentDetails = [[MidtransPaymentBankTransfer alloc] initWithBankTransferType:self.paymentType
                                                                                                          email:self.headerView.emailTextField.text];
    self.token.customerDetails.email = self.headerView.emailTextField.text;
    MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:self.token];
    
    [self showLoadingWithText:nil];
    [[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
        [self hideLoading];
        if (error) {
            [self handleTransactionError:error];
        } else {
            [self handleTransactionSuccess:result];
        }
    }];
}

- (void)tabChanged:(UISegmentedControl *)sender {
    [self selectTabAtIndex:sender.selectedSegmentIndex];
}

- (void)selectTabAtIndex:(NSInteger)index {
    VTGroupedInstruction *groupedInst = self.mainInstructions[index];
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

@end
