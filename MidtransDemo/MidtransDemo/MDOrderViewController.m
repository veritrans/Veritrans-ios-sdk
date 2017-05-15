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
    CC_CONFIG.paymentType = [[MDOptionManager shared].ccTypeOption.value integerValue];
    CC_CONFIG.saveCardEnabled = [[MDOptionManager shared].saveCardOption.value boolValue];
    CC_CONFIG.secure3DEnabled = [[MDOptionManager shared].secure3DOption.value boolValue];
    CC_CONFIG.acquiringBank = [[MDOptionManager shared].issuingBankOption.value integerValue];
    CC_CONFIG.predefinedInstallment = [MDOptionManager shared].installmentOption.value;
    CC_CONFIG.preauthEnabled = [[MDOptionManager shared].preauthOption.value boolValue];
    CC_CONFIG.promoEnabled = [[MDOptionManager shared].promoOption.value boolValue];
    
    CONFIG.customPaymentChannels = [[MDOptionManager shared].paymentChannel.value valueForKey:@"type"];
    CONFIG.customBCAVANumber = [MDOptionManager shared].bcaVAOption.value;
    CONFIG.customPermataVANumber = [MDOptionManager shared].permataVAOption.value;
    
    [[MidtransNetworkLogger shared] startLogging];
    
    self.amountView.backgroundColor = [UIColor mdThemeColor];
    __weak MDOrderViewController *wself = self;
    defaults_observe_object(@"md_color", ^(NSNotification *note){
        wself.amountView.backgroundColor = [UIColor mdThemeColor];
    });
}

- (void)dealloc {
    [[MidtransNetworkLogger shared] stopLogging];
}

- (IBAction)bayarPressed:(id)sender {
    MidtransAddress *addr = [MidtransAddress addressWithFirstName:@"first"
                                                         lastName:@"last"
                                                            phone:@""
                                                          address:@"MidPlaza 2, 4th Floor Jl. Jend. Sudirman Kav.10-11"
                                                             city:@"Jakarta"
                                                       postalCode:@"10220"
                                                      countryCode:@"IDN"];
    MidtransCustomerDetails *cst = [[MidtransCustomerDetails alloc] initWithFirstName:@"first"
                                                                             lastName:@"last"
                                                                                email:@"midtrans@mailinator.com"
                                                                                phone:@""
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
    UIColor *color = [MDOptionManager shared].colorOption.value;
    [MidtransUIThemeManager applyCustomThemeColor:color themeFont:font];
    
    NSArray *binFilter = @[];
    if ([[MDOptionManager shared].bniPointOption.value boolValue]) {
        binFilter = @[@"410505"];
    }
    //configure expire time
    MidtransTransactionExpire *expr = [MDOptionManager shared].expireTimeOption.value;
    //show hud
    [self.progressHUD showInView:self.navigationController.view];
    [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:trx
                                                                       itemDetails:@[itm]
                                                                   customerDetails:cst
                                                                       customField:nil
                                                                         binFilter:binFilter
                                                             transactionExpireTime:expr
                                                                        completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error)
     {
         if (error) {
             if ([error.localizedDescription isKindOfClass:[NSArray class]]) {
                 
             }
             else {
                 
             }
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
             [alert show];
         }
         else {
             MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
             paymentVC.paymentDelegate = self;
             [self.navigationController presentViewController:paymentVC animated:YES completion:nil];
         }
         
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
