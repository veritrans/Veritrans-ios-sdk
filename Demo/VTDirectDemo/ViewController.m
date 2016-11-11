//
//  ViewController.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "ViewController.h"
#import "SamplePaymentListViewController.h"
#import "TableViewCell.h"
#import "OptionViewController.h"
#import <MidtransKit/MidtransKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MBProgressHUD.h>

@implementation NSString (random)

+ (NSString *)randomWithLength:(NSUInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end

@interface ViewController () <MidtransUIPaymentViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray <MidtransItemDetail*>* itemDetails;
@property (nonatomic) BOOL isDone;
@property (nonatomic,strong)MidtransUIPaymentViewController *paymentVC;
@property (nonatomic,strong) NSString *transactionToken;
@end
#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDone = 0;
    //set default font
    NSArray *fontNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"custom_font"];
    if (!fontNames) {
        [[NSUserDefaults standardUserDefaults] setObject:[UIFont fontNamesForFamilyName:@"Changa"] forKey:@"custom_font"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //set default theme color
    NSData *themeColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme_color"];
    if (!themeColorData) {
        UIColor *themeColor = [UIColor colorWithRed:25/255. green:163/255. blue:239/255. alpha:1.0];
        themeColorData = [NSKeyedArchiver archivedDataWithRootObject:themeColor];
        [[NSUserDefaults standardUserDefaults] setObject:themeColorData forKey:@"theme_color"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.navigationController.view.userInteractionEnabled = YES;
    
    self.itemDetails = [self generateItemDetails];
}

- (IBAction)settingPressed:(UIBarButtonItem *)sender {
    OptionViewController *option = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    [self.navigationController pushViewController:option animated:YES];
}

- (IBAction)checkoutPressed:(UIBarButtonItem *)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Select Demo you want to see"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* uiFlow = [UIAlertAction
                             actionWithTitle:@"UI-FLOW Demo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [self initUIFlow];
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    UIAlertAction* coreFlow = [UIAlertAction
                               actionWithTitle:@"CORE-FLOW Demo"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self initCoreFlow];
                                   [view dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    [view addAction:uiFlow];
    [view addAction:coreFlow];
    [self presentViewController:view animated:YES completion:nil];
    
}
- (void)initCoreFlow {
    NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"vt_customer"];
    MidtransCustomerDetails *customerDetails = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    MidtransTransactionDetails *transactionDetails = [[MidtransTransactionDetails alloc] initWithOrderID:[NSString randomWithLength:20] andGrossAmount:[self grossAmountOfItemDetails:self.itemDetails]];
    
    if (customerDetails!=nil) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [MidtransUIThemeManager applyCustomThemeColor:[self myThemeColor] themeFont:[self myFontSource]];
        [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:transactionDetails itemDetails:self.itemDetails customerDetails:customerDetails customField:@{@"test":@"123"} transactionExpireTime:nil completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                SamplePaymentListViewController *sampleController = [[SamplePaymentListViewController alloc] initWithNibName:@"SamplePaymentListViewController" bundle:nil];
                sampleController.transactionToken = token;
                UINavigationController *sampleNavigationcontroller = [[UINavigationController alloc] initWithRootViewController:sampleController];
                [self presentViewController:sampleNavigationcontroller animated:YES completion:nil];
            }
            else {
            }

        }];

        //[[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:transactionDetails
          //                                                                 itemDetails:self.itemDetails
            //                                                           customerDetails:customerDetails
              //                                                              completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error)
       //  {
         //    [MBProgressHUD hideHUDForView:self.view animated:YES];
           //  if (!error) {
           //      SamplePaymentListViewController *sampleController = [[SamplePaymentListViewController alloc] initWithNibName:@"SamplePaymentListViewController" bundle:nil];
           //      sampleController.transactionToken = token;
            //     UINavigationController *sampleNavigationcontroller = [[UINavigationController alloc] initWithRootViewController:sampleController];
            //     [self presentViewController:sampleNavigationcontroller animated:YES completion:nil];
           //  }
           //  else {
           //  }
        // }];
    }
    else {
        OptionViewController *option = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        [self.navigationController pushViewController:option animated:YES];
    }
}
- (void)initUIFlow {
//    [CC_CONFIG setTokenStorageEnabled:YES];
    
    
    NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"vt_customer"];
    MidtransCustomerDetails *customerDetails = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    MidtransTransactionDetails *transactionDetails = [[MidtransTransactionDetails alloc] initWithOrderID:[NSString randomWithLength:20] andGrossAmount:[self grossAmountOfItemDetails:self.itemDetails]];
    
    if (customerDetails!=nil) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [MidtransUIThemeManager applyCustomThemeColor:[self myThemeColor] themeFont:[self myFontSource]];
       // MidtransTransactionExpire *expire = [[MidtransTransactionExpire alloc] initWithExpireTime:[NSDate date] expireDuration:1 withUnitTime:MindtransTimeUnitTypeMinute];

//        [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:transactionDetails itemDetails:self.itemDetails customerDetails:customerDetails customField:@{@"test":@"123"} transactionExpireTime:expire completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error){
//            NSLog(@"token-->%@",token);
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             if (!error) {
//                 self.paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
//                 self.paymentVC.delegate = self;
//
//                 [self presentViewController:self.paymentVC animated:YES completion:nil];
//             }
//             else {
//                 [self showAlertError:error];
//             }
//         }];
        [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:transactionDetails itemDetails:self.itemDetails customerDetails:customerDetails completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error)
         {
             NSLog(@"token--->%@",token);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error) {
                 self.paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
                 self.paymentVC.delegate = self;
                 
                 [self presentViewController:self.paymentVC animated:YES completion:nil];
             }
             else {
                 [self showAlertError:error];
             }
         }];


    }
    else {
        OptionViewController *option = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        [self.navigationController pushViewController:option animated:YES];
    }
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

- (void)showAlertError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"error: %@", error);
}

#pragma mark - MidtransUIPaymentViewControllerDelegate

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result {
    NSLog(@"success: %@", result);
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error {
    [self showAlertError:error];
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result {
    NSLog(@"pending: %@", result);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemDetails count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    cell.item = self.itemDetails[indexPath.row];
    return cell;
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
        MidtransItemDetail *itemDetail = [[MidtransItemDetail alloc] initWithItemID:[NSString randomWithLength:20] name:[NSString stringWithFormat:@"Item %i", i] price:@1000 quantity:@3];
        itemDetail.imageURL = [NSURL URLWithString:@"http://ecx.images-amazon.com/images/I/41blp4ePe8L._AC_UL246_SR190,246_.jpg"];
        [result addObject:itemDetail];
    }
    return result;
}

@end
