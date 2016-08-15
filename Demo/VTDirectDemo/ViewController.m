//
//  ViewController.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "ViewController.h"
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

@interface ViewController () <VTPaymentViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray <VTItemDetail*>* itemDetails;
@property (nonatomic) BOOL isDone;
@property (nonatomic,strong) NSString *transactionToken;
@end

@implementation ViewController

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
    NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"vt_customer"];
    VTCustomerDetails *customerDetails = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    VTTransactionDetails *transactionDetails = [[VTTransactionDetails alloc] initWithOrderID:[NSString randomWithLength:20] andGrossAmount:[self grossAmountOfItemDetails:self.itemDetails]];
    
    if (customerDetails!=nil) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [VTThemeManager applyCustomThemeColor:[self myThemeColor] themeFont:[self myFontSource]];
        
        [[VTMerchantClient sharedClient] requestTransactionTokenWithTransactionDetails:transactionDetails itemDetails:self.itemDetails customerDetails:customerDetails completion:^(TransactionTokenResponse * _Nullable token, NSError * _Nullable error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error) {
                 
                 VTPaymentViewController *vc = [[VTPaymentViewController alloc] initWithToken:token];
                 vc.delegate = self;
                 [self presentViewController:vc animated:YES completion:nil];
             }
             else {
                 NSLog(@"error-->%@",error);
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

- (VTFontSource *)myFontSource {
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
    return [[VTFontSource alloc] initWithFontNameBold:fontNameBold fontNameRegular:fontNameRegular fontNameLight:fontNameLight];
}

#pragma mark - VTPaymentViewControllerDelegate

- (void)paymentViewController:(VTPaymentViewController *)viewController paymentSuccess:(VTTransactionResult *)result {
    NSLog(@"success: %@", result);
}

- (void)paymentViewController:(VTPaymentViewController *)viewController paymentFailed:(NSError *)error {
    NSLog(@"error: %@", error);
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

- (NSNumber *)grossAmountOfItemDetails:(NSArray<VTItemDetail*>*)itemDetails {
    double totalPrice = 0;
    for (VTItemDetail *itemDetail in itemDetails) {
        totalPrice += (itemDetail.price.doubleValue * itemDetail.quantity.integerValue);
    }
    return @(totalPrice);
}

- (NSArray *)generateItemDetails {
    NSMutableArray *result = [NSMutableArray new];
    for (int i=0; i<6; i++) {
        VTItemDetail *itemDetail = [[VTItemDetail alloc] initWithItemID:[NSString randomWithLength:20] name:[NSString stringWithFormat:@"Item %i", i] price:@1000 quantity:@3];
        itemDetail.imageURL = [NSURL URLWithString:@"http://ecx.images-amazon.com/images/I/41blp4ePe8L._AC_UL246_SR190,246_.jpg"];
        [result addObject:itemDetail];
    }
    return result;
}

@end
