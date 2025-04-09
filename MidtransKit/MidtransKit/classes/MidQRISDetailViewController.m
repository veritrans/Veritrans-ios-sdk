//
//  MidQRISDetailViewController.m
//  MidtransKit
//
//  Created by Vanbungkring on 11/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//
#define IS_IPAD (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
#import <MidtransCoreKit/MidtransCoreKit.h>
#import "MidQRISDetailViewController.h"
#import "MIDGopayDetailView.h"
#import "MidtransDirectHeader.h"
#import "MidtransUINextStepButton.h"
#import "MIdtransUIBorderedView.h"
#import "VTGuideCell.h"
#import "VTClassHelper.h"
@interface MidQRISDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSArray *guides;
@property (strong, nonatomic) IBOutlet MIDGopayDetailView *view;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;
@property int deltaTime;
@property int currHours;
@property int currMinute;
@property int currSeconds;
@property (nonatomic,strong )NSTimer *timer;
@end

@implementation MidQRISDetailViewController
@dynamic view;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f,
                                                                      0.0f,
                                                                      24.0f,
                                                                      24.0f)];
    
    UIImage *image = [UIImage imageNamed:@"back" inBundle:VTBundle compatibleWithTraitCollection:nil];
    [backButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(backButtonDidTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = self.backBarButton;
    NSString *qrisPaymentMethodTitle = [NSString stringWithFormat:@"Pay with %@", self.paymentMethod.internalBaseClassIdentifier];
    self.title = [VTClassHelper getTranslationFromAppBundleForString:qrisPaymentMethodTitle];
    self.view.merchantName.text = [[NSUserDefaults standardUserDefaults] objectForKey:MIDTRANS_CORE_MERCHANT_NAME];
    self.view.guideTableView.delegate = self;
    self.view.guideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.guideTableView.tableFooterView = [UIView new];
    self.view.guideTableView.dataSource = self;
    [self.view.guideTableView registerNib:[UINib nibWithNibName:@"MidtransDirectHeader" bundle:VTBundle] forCellReuseIdentifier:@"MidtransDirectHeader"];
    [self.view.guideTableView registerNib:[UINib nibWithNibName:@"VTGuideCell" bundle:VTBundle] forCellReuseIdentifier:@"VTGuideCell"];
    
    //Get current year
    self.view.expireTimesLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Please complete your payment in"];
    
    NSDateFormatter *expiredDateFormatter = [[NSDateFormatter alloc] init];
    [expiredDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [expiredDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
    [startDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [startDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [expiredDateFormatter dateFromString:self.result.qrisExpirationRaw];
    NSDate *startDate = [startDateFormatter dateFromString:self.result.transactionTime];
    self.deltaTime = [endDate timeIntervalSinceDate:startDate];
    
    self.currSeconds = self.deltaTime % 60;
    self.currMinute = (self.deltaTime / 60) % 60;
    self.currHours = self.deltaTime / 3600;
    [self startTimer];
    
    self.view.topWrapperView.hidden = YES;
    self.view.qrcodeWrapperView.hidden = NO;
    [self.view.finishPaymentButton setTitle:@"Pay Now" forState:UIControlStateNormal];
    [self fetchQRCode];
    NSString *filenameByLanguage = [[MidtransDeviceHelper deviceCurrentLanguage] stringByAppendingFormat:@"_ipad_%@", self.paymentMethod.shortName];
    NSString *guidePath = [VTBundle pathForResource:filenameByLanguage ofType:@"plist"];
    if (guidePath == nil) {
        guidePath = [VTBundle pathForResource:[NSString stringWithFormat:@"en_ipad_%@",self.paymentMethod.shortName] ofType:@"plist"];
    }
    NSMutableArray *arrayOfGuide = [NSMutableArray new];
    arrayOfGuide = [NSMutableArray arrayWithArray:[VTClassHelper instructionsFromFilePath:guidePath]];
    self.guides = arrayOfGuide;
    [self.view.guideTableView reloadData];
    [self.view layoutIfNeeded];
    
    
    self.view.amountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
}
- (void)startTimer{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownFired) userInfo:nil repeats:YES];
}
- (void)countDownFired {
    if((self.currMinute > 0 || self.currHours >= 0) && self.currMinute >=0){
        if(self.currSeconds == 0) {
            self.currMinute -=1;
            self.currSeconds = 59;
        }
        else if(self.currSeconds > 0) {
            self.currSeconds -= 1;
        }
        if(self.currMinute>-1)
            [self.view.expireTimesLabel setText:[NSString stringWithFormat:@"%@ %@%d%@%02d",@" ",[VTClassHelper getTranslationFromAppBundleForString:@"Please complete your payment in"],self.currMinute,@":",self.currSeconds]];
    }
    else {
        [self.timer invalidate];
        self.view.expireTimesLabel.text = [VTClassHelper getTranslationFromAppBundleForString:@"Time's Up"];
    }
}

- (void)backButtonDidTapped:(id)sender {
    NSString *title;
    NSString *content;
    title = [VTClassHelper getTranslationFromAppBundleForString:@"Finish Payment"];
    content = [VTClassHelper getTranslationFromAppBundleForString:@"Make sure the QR code successfully scanned and payment has been completed within the Shopee app."];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:content
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
        NSLog(@"Cancel action");
    }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
            [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
            [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
        }];
    }
    
}
- (IBAction)gopayLogoButtonDidtapped:(id)sender {
    [self processCheckOut];
}
- (IBAction)finishButtonDidTapped:(id)sender {
    [self processCheckOut];
}
- (void)processCheckOut {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSDictionary *userInfo = @{TRANSACTION_RESULT_KEY:self.result};
        [[NSNotificationCenter defaultCenter] postNotificationName:TRANSACTION_PENDING object:nil userInfo:userInfo];
    }];
}
- (void)fetchQRCode {
    [self showLoadingWithText:@"Loading QR Code"];
    self.view.qrcodeReloadImage.hidden = YES;
    NSString *imageUrl = [self.result.additionalData objectForKey:@"qris_url"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [self hideLoading];
        if (!error) {
            self.view.qrcodeImage.image = [UIImage imageWithData:data];
        } else {
            self.view.qrcodeReloadImage.hidden = NO;
        }
        
    }];
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
    [label setText:@"How to pay?"];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTGuideCell"];
    if(indexPath.row %2 ==0) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }
    if (IS_IPAD && indexPath.row == 1) {
        cell.imageBottomInstruction.hidden = NO;
        cell.bottomNotes.hidden = YES;
        [cell.imageBottomInstruction setImage:[UIImage imageNamed:@"gopay_scan_2" inBundle:VTBundle compatibleWithTraitCollection:nil]];
        cell.bottomImageInstructionsConstraints.constant = 120.0f;
    }
    [cell setInstruction:self.guides[indexPath.row] number:indexPath.row+1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end
