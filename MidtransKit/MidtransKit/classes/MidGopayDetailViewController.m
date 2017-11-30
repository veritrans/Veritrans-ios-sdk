//
//  MidGopayDetailViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 11/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidGopayDetailViewController.h"
#import "MIDGopayDetailView.h"
#import "MidtransDirectHeader.h"
#import "MidtransUINextStepButton.h"
#import "MIdtransUIBorderedView.h"
#import "VTGuideCell.h"
#import "VTClassHelper.h"
@interface MidGopayDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSArray *guides;
@property (strong, nonatomic) IBOutlet MIDGopayDetailView *view;
@end

@implementation MidGopayDetailViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pay using GO-PAY";
    self.view.guideTableView.delegate = self;
    self.view.guideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.guideTableView.tableFooterView = [UIView new];
    self.view.guideTableView.dataSource = self;
    [self.view.guideTableView registerNib:[UINib nibWithNibName:@"MidtransDirectHeader" bundle:VTBundle] forCellReuseIdentifier:@"MidtransDirectHeader"];
    [self.view.guideTableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    
    if (IPAD) {
        self.view.topWrapperView.hidden = YES;
        self.view.qrcodeWrapperView.hidden = NO;
        [self.view.finishPaymentButton setTitle:@"Finish Payment" forState:UIControlStateNormal];
        [self fetchQRCode];
        NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_ipad_%@", MIDTRANS_PAYMENT_GOPAY];
        NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
        if (guidePath == nil) {
            guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_ipad_%@",MIDTRANS_PAYMENT_GOPAY] ofType:@"plist"];
        }
        NSMutableArray *arrayOfGuide = [NSMutableArray new];
        arrayOfGuide = [NSMutableArray arrayWithArray:[VTClassHelper instructionsFromFilePath:guidePath]];
        [arrayOfGuide removeObjectsInRange:NSMakeRange(0, 2)];
        self.guides = arrayOfGuide;
        [self.view.guideTableView reloadData];
        
        [self.view layoutIfNeeded];

        
    } else {
        self.view.topWrapperView.hidden = NO;
        
        self.view.qrcodeWrapperView.hidden = YES;
    }
    
    self.view.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)finishButtonDidTapped:(id)sender {
    if (IPAD) {
        NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
        NSURL *gojekConstructURL = [NSURL URLWithString:[self.result.additionalData objectForKey:@"deeplink_url"]];
        if ([[UIApplication sharedApplication] canOpenURL:gojekConstructURL]) {
            [[UIApplication sharedApplication] openURL:gojekConstructURL];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
       // "gojek://gopay/merchanttransfer?tref=i3VwApFnnG&amount=10000&activity=GP:RR"
        
    }
}
- (void)fetchQRCode {
    [self showLoadingWithText:@"Loading QR Code"];
     self.view.qrcodeReloadImage.hidden = YES;
    NSString *imageUrl = [self.result.additionalData objectForKey:@"qr_code_url"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [self hideLoading];
        if (!error) {
            self.view.qrcodeImage.image = [UIImage imageWithData:data];
        } else {
            self.view.qrcodeReloadImage.hidden = NO;
        }
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)qrcodeReloadDidTapped:(id)sender {
    [self fetchQRCode];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.guides.count;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    if (IPAD && indexPath.row == 1) {
        cell.imageBottomInstruction.hidden = NO;
        cell.bottomImageInstructionsConstraints.constant = 120.0f;
    }
    [cell setInstruction:self.guides[indexPath.row] number:indexPath.row+1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IPAD && indexPath.row == 1) {
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
                cell = [self.view.guideTableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
            });
            [cell setInstruction:self.guides[indexPath.row] number:indexPath.row+1];
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
        
    }
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
