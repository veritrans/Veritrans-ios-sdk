//
//  MDOrderViewController.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/27/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOrderViewController.h"
#import "MDUtils.h"
#import "MDOptionManager.h"
#import <MidtransKit/MidtransKit.h>
#import <JGProgressHUD/JGProgressHUD.h>

@interface MDOrderViewController () <MidtransUIPaymentViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (nonatomic) JGProgressHUD *progressHUD;
@end

@implementation MDOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Order Review";
    
    self.progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.progressHUD.textLabel.text = @"Loading...";
    
    NSString *clientkey;
    NSString *merchantServer;
    switch (CC_CONFIG.paymentType) {
        case MTCreditCardPaymentTypeOneclick:
            clientkey = @"VT-client-E4f1bsi1LpL1p5cF";
            merchantServer = @"https://rakawm-snap.herokuapp.com";
            break;
        default:
            clientkey = @"VT-client-cwmvxnYb-CTkaAgz";
            merchantServer = @"https://demo-merchant-server.herokuapp.com";
            break;
    }
    
    [CONFIG setClientKey:clientkey
             environment:MidtransServerEnvironmentSandbox
       merchantServerURL:merchantServer];
    
    //forced to use token storage
    CC_CONFIG.tokenStorageEnabled = YES;
    
    self.amountView.backgroundColor = [UIColor mdThemeColor];
    defaults_observe_object(@"md_color", ^(NSNotification *note){
        self.amountView.backgroundColor = [UIColor mdThemeColor];
    });
}

- (IBAction)bayarPressed:(id)sender {
    MidtransAddress *addr = [MidtransAddress addressWithFirstName:@"first"
                                                         lastName:@"last"
                                                            phone:@"088888888888"
                                                          address:@"MidPlaza 2, 4th Floor Jl. Jend. Sudirman Kav.10-11"
                                                             city:@"Jakarta"
                                                       postalCode:@"10220"
                                                      countryCode:@"IDN"];
    MidtransCustomerDetails *cst = [[MidtransCustomerDetails alloc] initWithFirstName:@"first"
                                                                             lastName:@"last"
                                                                                email:@"midtrans@mailinator.com"
                                                                                phone:@"088888888888"
                                                                      shippingAddress:addr
                                                                       billingAddress:addr];
    cst.customerIdentifier = @"midtrans@mailinator.com";
    MidtransItemDetail *itm = [[MidtransItemDetail alloc] initWithItemID:[NSString randomWithLength:20]
                                                                    name:@"Midtrans Pillow"
                                                                   price:@20000
                                                                quantity:@1];
    MidtransTransactionDetails *trx = [[MidtransTransactionDetails alloc] initWithOrderID:[NSString randomWithLength:20]
                                                                           andGrossAmount:itm.price];
    
    //configure theme
    MidtransUIFontSource *font = [[MidtransUIFontSource alloc] initWithFontNameBold:@"SourceSansPro-Bold"
                                                                    fontNameRegular:@"SourceSansPro-Regular"
                                                                      fontNameLight:@"SourceSansPro-Light"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:[MDOptionManager shared].colorValue];
    [MidtransUIThemeManager applyCustomThemeColor:color themeFont:font];
    
    //configure expire time
    MidtransTransactionExpire *expr;
    NSData *data = [[MDOptionManager shared] expireTimeValue];
    if (data) {
        expr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    //show hud
    [self.progressHUD showInView:self.navigationController.view];

    [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:trx
                                                                       itemDetails:@[itm]
                                                                   customerDetails:cst
                                                                       customField:nil
                                                             transactionExpireTime:expr
                                                                        completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error)
     {
         MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
         paymentVC.paymentDelegate = self;
         [self.navigationController presentViewController:paymentVC animated:YES completion:nil];
         
         //hide hud
         [self.progressHUD dismissAnimated:YES];
     }];
}

#pragma mark - MidtransUIPaymentViewControllerDelegate

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result {
    NSLog(@"[MIDTRANS] success %@", result);
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result {
    NSLog(@"[MIDTRANS] pending %@", result);
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error {
    NSLog(@"[MIDTRANS] error %@", error);
}
- (void)paymentViewController_paymentCanceled:(MidtransUIPaymentViewController *)viewController {
    NSLog(@"[MIDTRANS] canceled");
}

@end
