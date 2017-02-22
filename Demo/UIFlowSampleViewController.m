//
//  UIFlowSampleViewController.m
//  VTDirectDemo
//
//  Created by Vanbungkring on 12/21/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "UIFlowSampleViewController.h"
#import "TableViewCell.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransKit/MidtransUIThemeManager.h>
#import <MidtransCoreKit/MidtransItemDetail.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "SamplePaymentListTableViewCell.h"
@interface UIFlowSampleViewController () <UITableViewDelegate,UITableViewDataSource,MidtransUIPaymentViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *sampleList;
@property (nonatomic) NSArray <MidtransItemDetail*>* itemDetails;
@property (nonatomic,strong) MidtransTransactionDetails * transactionDetails;

@end

@implementation UIFlowSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Choose your payment mode";
    self.sampleList = @[@"Normal Payment",@"Specific Payment",@"Payment With Limit Time",@"Custom Theme",@"Custom Field"];
    [self.tableView reloadData];
    // Do any additional setup after loading the view from its nib.
    
    [[MidtransNetworkLogger shared] startLogging];
}

- (void)dealloc {
    [[MidtransNetworkLogger shared] stopLogging];
}

- (void)initPayment {
    ///1 Set the customer details
    
    /////2 set transactionDetails
    
    //// set item details
    self.itemDetails = [self generateItemDetails];
    
    self.transactionDetails = [[MidtransTransactionDetails alloc]
                               initWithOrderID:[NSString randomWithLength:10]
                               andGrossAmount:[self grossAmountOfItemDetails:self.itemDetails]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sampleList count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SamplePaymentListTableViewCell *cell = (SamplePaymentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SamplePaymentListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SamplePaymentListTableViewCell" owner:self options:nil] firstObject];
        [tableView registerNib:[UINib nibWithNibName:@"SamplePaymentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SamplePaymentListTableViewCell"];
    }
    cell.paymentName.text = self.sampleList[indexPath.row];
    cell.paymentDescription.hidden = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self initPayment];
    
    [MidtransUIThemeManager applyStandardTheme];
    
    switch (indexPath.row) {
        case 0:
            [self normalPaymentMode];
            break;
        case 1:
            [self specificPaymentMethod];
            break;
        case 2:
            [self limitPaymentTime];
            break;
        case 3:
            [self customTheme];
            break;
        case 4:
            [self customField];
        default:
            break;
    }
}
-(void)customField {
    NSMutableArray *arrayOfCustomField = [NSMutableArray new];
    
    [arrayOfCustomField addObject:@{MIDTRANS_CUSTOMFIELD_1:@"custom1"}];
    [arrayOfCustomField addObject:@{MIDTRANS_CUSTOMFIELD_2:@"custom2"}];
    [arrayOfCustomField addObject:@{MIDTRANS_CUSTOMFIELD_3:@"custom3"}];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:self.transactionDetails
                                                                       itemDetails:self.itemDetails
                                                                   customerDetails:self.customerDetails
                                                                       customField:arrayOfCustomField
                                                             transactionExpireTime:nil
                                                                        completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (!error) {
             MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token andPaymentFeature:MidtransPaymentFeatureCreditCard];
             paymentVC.paymentDelegate = self;
             
             [self.navigationController presentViewController:paymentVC animated:YES completion:nil];
         }
         else {
             
         }
     }];
}
- (void)customTheme {
    MidtransUIFontSource *fontSource = [self myFontSource];
    UIColor *themeColor = [self myThemeColor];
    [MidtransUIThemeManager applyCustomThemeColor:themeColor themeFont:fontSource];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:self.transactionDetails
                                                                       itemDetails:self.itemDetails
                                                                   customerDetails:self.customerDetails
                                                                        completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error){
                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                            if (!error) {
                                                                                MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
                                                                                paymentVC.paymentDelegate = self;
                                                                                
                                                                                [self.navigationController presentViewController:paymentVC animated:YES completion:nil];
                                                                            }
                                                                            else {
                                                                                
                                                                            }
                                                                        }];
    
}
- (void)limitPaymentTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSDate *now = [NSDate date];
    MidtransTransactionExpire *expireTime = [[MidtransTransactionExpire alloc] initWithExpireTime:now expireDuration:1 withUnitTime:MindtransTimeUnitTypeHour];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:self.transactionDetails
                                                                       itemDetails:self.itemDetails
                                                                   customerDetails:self.customerDetails
                                                                       customField:nil
                                                             transactionExpireTime:expireTime
                                                                        completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error){
                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                            if (!error) {
                                                                                MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
                                                                                paymentVC.paymentDelegate = self;
                                                                                
                                                                                [self.navigationController presentViewController:paymentVC animated:YES completion:nil];
                                                                            }
                                                                            else {
                                                                                
                                                                            }
                                                                        }];
    
}
- (void)specificPaymentMethod {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:self.transactionDetails
                                                                       itemDetails:self.itemDetails
                                                                   customerDetails:self.customerDetails
                                                                        completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error){
                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                            if (!error) {
                                                                                MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token andPaymentFeature:MidtransPaymentFeatureCreditCard];
                                                                                paymentVC.paymentDelegate = self;
                                                                                
                                                                                [self.navigationController presentViewController:paymentVC animated:YES completion:nil];
                                                                            }
                                                                            else {
                                                                                
                                                                            }
                                                                        }];
    
    
}
- (void)normalPaymentMode {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:self.transactionDetails
                                                                       itemDetails:self.itemDetails
                                                                   customerDetails:self.customerDetails
                                                                        completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error){
                                                                            NSLog(@"token->%@",token);
                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                            if (!error) {
                                                                                MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
                                                                                paymentVC.paymentDelegate = self;
                                                                                
                                                                                [self.navigationController presentViewController:paymentVC animated:YES completion:nil];
                                                                            }
                                                                            else {
                                                                                
                                                                            }
                                                                        }];
}


#pragma mark - Helper

- (NSNumber *)grossAmountOfItemDetails:(NSArray<MidtransItemDetail*>*)itemDetails {
    double totalPrice = 0;
    for (MidtransItemDetail *itemDetail in itemDetails) {
        totalPrice += (itemDetail.price.doubleValue * itemDetail.quantity.integerValue);
    }
    return @(totalPrice);
}

- (NSArray *)generateItemDetails {
    NSMutableArray *result = [NSMutableArray new];
    for (int i=0; i<6; i++) {
        MidtransItemDetail *itemDetail = [[MidtransItemDetail alloc] initWithItemID:[NSString randomWithLength:20] name:[NSString stringWithFormat:@"Item %i", i] price:@100 quantity:@3];
        itemDetail.imageURL = [NSURL URLWithString:@"http://ecx.images-amazon.com/images/I/41blp4ePe8L._AC_UL246_SR190,246_.jpg"];
        [result addObject:itemDetail];
    }
    return result;
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result {
    NSLog(@"result %@", result);
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result {
    NSLog(@"result %@", result);
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error {
    NSLog(@"error %@", error);
}
- (void)paymentViewController_paymentCanceled:(MidtransUIPaymentViewController *)viewController {
    
}
- (UIColor *)myThemeColor {
    NSData *themeColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme_color"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:themeColorData];
}

- (MidtransUIFontSource *)myFontSource {
    NSString *fontNameBold;
    NSString *fontNameRegular;
    NSString *fontNameLight;
    NSArray *fontNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"custom_font"];
    for (NSString *fontName in fontNames) {
        if ([fontName rangeOfString:@"-bold" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            fontNameBold = fontName;
        } else if ([fontName rangeOfString:@"-regular" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            fontNameRegular = fontName;
        } else if ([fontName rangeOfString:@"-light" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            fontNameLight = fontName;
        }
    }
    return [[MidtransUIFontSource alloc] initWithFontNameBold:fontNameBold fontNameRegular:fontNameRegular fontNameLight:fontNameLight];
}

@end
