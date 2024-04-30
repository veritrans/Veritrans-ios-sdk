//
//  MDOrderViewController.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 3/27/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOrderViewController.h"
#import "MDUtils.h"
#import "AddAddressViewController.h"
#import <ACFloatingTextField.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/SNPFreeTextDataModels.h>
#import "MDOptionManager.h"
#import <MidtransKit/MidtransKit.h>
#import <JGProgressHUD/JGProgressHUD.h>
#import "MidtransDemoAppConfig.h"

@interface MDOrderViewController () <MidtransUIPaymentViewControllerDelegate,MidtransPaymentWebControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerItemLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UITextField *snaptokenTextField;
@property (strong, nonatomic) NSNumber *totalAmount;
@property (nonatomic) MidtransPaymentFeature directPaymentFeature;
@property (nonatomic) MidtransUIPaymentViewController *paymentVC;

@property (nonatomic) JGProgressHUD *progressHUD;
@end

@implementation MDOrderViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.addressLabel.text = [NSString stringWithFormat:@" %@, %@ - %@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_ADDRESS"],[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_CITY"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_POSTAL_CODE"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_COUNTRY"]
                              ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalAmount = [NSNumber numberWithInt:DEMO_APP_ITEM_PRICE];
    NSString *formattedPrice = [self formattedISOCurrencyNumber:self.totalAmount];
    self.totalAmountLabel.text = self.pricePerItemLabel.text = formattedPrice;
    [self.payButton setTitle:[NSString stringWithFormat:@"Pay %@", formattedPrice] forState:UIControlStateNormal];
    self.emailTextField.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];;
    self.userNameTextField.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];;
    self.phoneNumberTextfield.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];;
    
    self.userNameTextField.text =[NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_FIRST_NAME"],[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_LAST_NAME"]];
    self.emailTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_EMAIL"];
    
    self.phoneNumberTextfield.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_PHONE"];
    
    self.emailTextField.enabled = NO;
    self.userNameTextField.enabled = NO;
    self.phoneNumberTextfield.enabled = NO;
    
    [self.editButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.title = @"Order Review";
    
    self.progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.progressHUD.textLabel.text = @"Loading...";
    
    NSString *clientkey;
    NSString *merchantServer;
    CC_CONFIG.paymentType = [[MDOptionManager shared].ccTypeOption.value integerValue];
    switch (CC_CONFIG.paymentType) {
        case MTCreditCardPaymentTypeOneclick:
            clientkey = DEMO_STORE_MERCHANT_CLIENT_KEY_SANDBOX;
            merchantServer = DEMO_STORE_MERCHANT_SERVER_URL_SANDBOX;
            break;
        default:
            clientkey = DEMO_STORE_MERCHANT_CLIENT_KEY_SANDBOX;
            merchantServer = DEMO_STORE_MERCHANT_SERVER_URL_SANDBOX;
            break;
    }
    [CONFIG setClientKey:clientkey
             environment:MidtransServerEnvironmentSandbox
       merchantServerURL:merchantServer];
    
    UICONFIG.hideStatusPage = NO;
    CC_CONFIG.authenticationType = [[MDOptionManager shared].authTypeOption.value integerValue];
    CC_CONFIG.saveCardEnabled =[[MDOptionManager shared].saveCardOption.value boolValue];
    CC_CONFIG.acquiringBank = [[MDOptionManager shared].issuingBankOption.value integerValue];
    CC_CONFIG.predefinedInstallment = [MDOptionManager shared].installmentOption.value;
    CC_CONFIG.preauthEnabled = [[MDOptionManager shared].preauthOption.value boolValue];
    CC_CONFIG.promoEnabled = [[MDOptionManager shared].promoOption.value boolValue];
    CC_CONFIG.showFormCredentialsUser = YES;
    
    /*set custom free text for bca*/
    NSDictionary *inquiryConstructor=@{@"en":@"inquiry text in English",@"id":@"inquiry Text in ID"};
    NSDictionary *inquiryConstructor2=@{@"en":@"inquiry text in English",@"id":@"inquiry Text in ID"};
    NSDictionary *paymentConstructor=@{@"en":@"payment text in English",@"id":@"payment Text in ID"};
    
    NSDictionary *freeText = @{@"inquiry":@[inquiryConstructor,inquiryConstructor2],@"payment":@[paymentConstructor]};
    CONFIG.customFreeText = freeText;
    CONFIG.currency = [MidtransHelper currencyFromString:[MDOptionManager shared].currencyOption.value];
    CONFIG.customPaymentChannels = [[MDOptionManager shared].paymentChannel.value valueForKey:@"type"];
    CONFIG.customBCAVANumber = [MDOptionManager shared].bcaVAOption.value;
    CONFIG.customBNIVANumber = [MDOptionManager shared].bniVAOption.value;
    CONFIG.customPermataVANumber = [MDOptionManager shared].permataVAOption.value;
    CONFIG.customCimbVANumber = [MDOptionManager shared].cimbVAOption.value;
    [[MidtransNetworkLogger shared] startLogging];
    
    [self handleDeeplinkUrlConfig];
    self.directPaymentFeature = [[MDOptionManager shared].directPaymentFeature.value intValue];
    
    self.amountView.backgroundColor = [UIColor mdThemeColor];
    __weak MDOrderViewController *wself = self;
    defaults_observe_object(@"md_color", ^(NSNotification *note) {
        wself.amountView.backgroundColor = [UIColor mdThemeColor];
    });
}

- (void)dealloc {
    [[MidtransNetworkLogger shared] stopLogging];
}

- (IBAction)bayarPressed:(id)sender {
    
    MidtransAddress *addr = [MidtransAddress addressWithFirstName:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_FIRST_NAME"]
                                                         lastName:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_LAST_NAME"]
                                                            phone:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_PHONE"]
                                                          address:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_ADDRESS"]
                                                             city:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_CITY"]
                                                       postalCode:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_POSTAL_CODE"]
                                                      countryCode:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_COUNTRY"]];
    
    MidtransCustomerDetails *cst = [[MidtransCustomerDetails alloc] initWithFirstName:self.userNameTextField.text
                                                                             lastName:nil
                                                                                email:self.emailTextField.text
                                                                                phone:self.phoneNumberTextfield.text
                                                                      shippingAddress:addr
                                                                       billingAddress:addr];
    cst.customerIdentifier = @"3A8788CE-B96F-449C-8180-B5901A08B50A";
    MidtransItemDetail *itm = [[MidtransItemDetail alloc] initWithItemID:[NSString randomWithLength:20]
                                                                    name:@"Midtrans Pillow"
                                                                   price:self.totalAmount
                                                                quantity:@1];
    
    MidtransTransactionDetails *trx = [[MidtransTransactionDetails alloc] initWithOrderID:[NSString randomWithLength:20]
                                                                           andGrossAmount:self.totalAmount andCurrency:CONFIG.currency];
    
    //configure theme
    MidtransUIFontSource *font = [[MidtransUIFontSource alloc] initWithFontNameBold:@"SourceSansPro-Bold"
                                                                    fontNameRegular:@"SourceSansPro-Regular"
                                                                      fontNameLight:@"SourceSansPro-Light"];
    UIColor *color = [MDOptionManager shared].colorOption.value;
    [MidtransUIThemeManager applyCustomThemeColor:color themeFont:font];
    
    NSPredicate *predicateLength = [NSPredicate predicateWithFormat:@"SELF.length > 0"];
    NSArray *binFilter = [[[[[MDOptionManager shared] binFilterOption] value] filteredArrayUsingPredicate:predicateLength] valueForKey:@"lowercaseString"];
    NSArray *blacklistBin = @[];
    
    //configure expire time
    
    MidtransTransactionExpire * optExpireTime = [[[MDOptionManager shared] expireTimeOption] value];
    MindtransTimeUnitType unit;
    if ([optExpireTime.unit isEqualToString:@"MINUTE"]) {
        unit = MindtransTimeUnitTypeMinute;
    }
    else if ([optExpireTime.unit isEqualToString:@"MINUTES"]) {
        unit = MindtransTimeUnitTypeMinutes;
    }
    else if ([optExpireTime.unit isEqualToString:@"HOUR"]) {
        unit = MindtransTimeUnitTypeHour;
    }
    else if ([optExpireTime.unit isEqualToString:@"HOURS"]) {
        unit = MindtransTimeUnitTypeHours;
    }
    else if ([optExpireTime.unit isEqualToString:@"DAY"]) {
        unit = MindtransTimeUnitTypeDay;
    }
    else if ([optExpireTime.unit isEqualToString:@"DAYS"]) {
        unit = MindtransTimeUnitTypeDays;
    }
    else {
        unit = MindtransTimeUnitTypeHour;
    }
    MidtransTransactionExpire *expireTime = [[MidtransTransactionExpire alloc] initWithExpireTime:[NSDate date] expireDuration:optExpireTime.duration withUnitTime:unit];
    //show hud
    [self.progressHUD showInView:self.navigationController.view];
    
    NSMutableArray *arrayOfCustomField = [NSMutableArray new];
    NSArray *value = [[[MDOptionManager shared] customFieldOption] value];
    if (value[0]) {
        [arrayOfCustomField addObject:@{MIDTRANS_CUSTOMFIELD_1:value[0]}];
    }
    if (value[1]) {
        [arrayOfCustomField addObject:@{MIDTRANS_CUSTOMFIELD_2:value[1]}];
    }
    if (value[2]) {
        [arrayOfCustomField addObject:@{MIDTRANS_CUSTOMFIELD_3:value[2]}];
    }
    
    [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:trx
                                                                       itemDetails:@[itm]
                                                                   customerDetails:cst
                                                                       customField:arrayOfCustomField
                                                                         binFilter:binFilter
                                                                blacklistBinFilter:blacklistBin
                                                             transactionExpireTime:optExpireTime.duration>0? expireTime : nil
                                                                        completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error)
     
     {
        if (error) {
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Error"
                                        message:error.localizedDescription
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction
                                       actionWithTitle:@"Close"
                                       style:UIAlertActionStyleDefault
                                       handler:nil];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            if (self.directPaymentFeature != MidtransPaymentFeatureNone) {
                self.paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token andPaymentFeature:self.directPaymentFeature];
            } else {
                self.paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
            }
            self.paymentVC.paymentDelegate = self;
            [self.navigationController presentViewController:self.paymentVC animated:YES completion:nil];
        }
        
        //hide hud
        [self.progressHUD dismissAnimated:YES];
    }];
}

#pragma mark - MidtransUIPaymentViewControllerDelegate

- (IBAction)editCustomerAddressButtonDidTapped:(id)sender {
    if (self.editButton.isSelected ==  true) {
        [self.editButton setSelected:NO];
        self.emailTextField.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];;
        self.userNameTextField.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];;
        self.phoneNumberTextfield.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];;
        
        self.emailTextField.enabled = NO;
        self.userNameTextField.enabled = NO;
        self.phoneNumberTextfield.enabled = NO;
        [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:@"USER_DEMO_CONTENT_EMAIL"];
        [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumberTextfield.text forKey:@"USER_DEMO_CONTENT_PHONE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else {
        [self.editButton setSelected:YES];
        self.emailTextField.backgroundColor = [UIColor clearColor];
        self.userNameTextField.backgroundColor = [UIColor clearColor];
        self.phoneNumberTextfield.backgroundColor = [UIColor clearColor];
        
        self.emailTextField.enabled = YES;
        self.userNameTextField.enabled = YES;
        self.phoneNumberTextfield.enabled = YES;
        NSLog(@"edited");
    }
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result {
    NSLog(@"[MIDTRANS] success %@", result);
    
    [self showAlertWithResult:result];
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result {
    NSLog(@"[MIDTRANS] pending %@", result);
    [self showAlertWithResult:result];
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error {
    NSLog(@"[MIDTRANS] error %@", error);
    [self showAlertWithError:error];
}
- (void)paymentViewController_paymentCanceled:(MidtransUIPaymentViewController *)viewController {
    NSLog(@"[MIDTRANS] canceled");
    [self showAlertCancelled];
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentDeny:(MidtransTransactionResult *)result{
    NSLog(@"[MIDTRANS] Deny %@", result);
    [self showAlertWithResult:result];
}

- (void)handleDeeplinkUrlConfig{
    NSArray *selectedEnabledPayments = [MDOptionManager shared].paymentChannel.value;
    if (selectedEnabledPayments) {
        for (NSDictionary* enabledPayment in selectedEnabledPayments){
            NSString *paymentType = [enabledPayment valueForKey:@"type"];
            if ([paymentType isEqualToString:@"gopay"]) {
                CONFIG.callbackSchemeURL = @"demo.midtrans://";
                CONFIG.shopeePayCallbackURL = nil;
                CONFIG.uobCallbackURL = nil;
            }
            if ([paymentType isEqualToString:@"shopeepay"]) {
                CONFIG.shopeePayCallbackURL = @"demo.midtrans://";
                CONFIG.callbackSchemeURL = nil;
                CONFIG.uobCallbackURL = nil;
            }
            if ([paymentType isEqualToString:@"uob_ezpay"]) {
                CONFIG.uobCallbackURL = @"demo.midtrans://";
                CONFIG.shopeePayCallbackURL = nil;
                CONFIG.callbackSchemeURL = nil;
            }
            if ([paymentType isEqualToString:@"bank_transfer"]) {
                CONFIG.uobCallbackURL = nil;
                CONFIG.shopeePayCallbackURL = nil;
                CONFIG.callbackSchemeURL = nil;
            }
        }
    } else {
        CONFIG.callbackSchemeURL = @"demo.midtrans://";
        CONFIG.shopeePayCallbackURL = @"demo.midtrans://";
        CONFIG.uobCallbackURL = @"demo.midtrans://";
    }
}

- (void)showAlertWithResult:(MidtransTransactionResult *)result {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:[NSString stringWithFormat:@"Payment using %@", result.paymentType]
                                message:[NSString stringWithFormat:@"Transaction id %@ status is %@", result.transactionId, result.transactionStatus]
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction
                                   actionWithTitle:@"Close"
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)showAlertWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Error"
                                message:[NSString stringWithFormat:@"Transaction error : %@", error.localizedFailureReason]
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction
                                   actionWithTitle:@"Close"
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)showAlertCancelled {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Transaction Cancelled"
                                message:@"Transaction is cancelled by user"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction
                                   actionWithTitle:@"Close"
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)editAddressViewController:(id)sender {
    AddAddressViewController *addAddressVC = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
    [self.navigationController pushViewController:addAddressVC animated:YES];
}
- (IBAction)payWithSnapPressed:(id)sender {
    if (!self.snaptokenTextField.text.SNPisEmpty)
    [[MidtransMerchantClient shared]requestTransacationWithCurrentToken:self.snaptokenTextField.text completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error) {
            if (error) {
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Error"
                                            message:error.localizedDescription
                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okButton = [UIAlertAction
                                           actionWithTitle:@"Close"
                                           style:UIAlertActionStyleDefault
                                           handler:nil];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                if (self.directPaymentFeature != MidtransPaymentFeatureNone) {
                    self.paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token andPaymentFeature:self.directPaymentFeature];
                } else {
                    self.paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:token];
                }
                self.paymentVC.paymentDelegate = self;
                [self.navigationController presentViewController:self.paymentVC animated:YES completion:nil];
            }
            //hide hud
            [self.progressHUD dismissAnimated:YES];
        }];
}


- (NSString *)formattedISOCurrencyNumber:(NSNumber *)number {
    NSNumberFormatter *currencyFormatter = [NSNumberFormatter multiCurrencyFormatter:CONFIG.currency];
    currencyFormatter.formatWidth = 0;
    NSInteger count = [[currencyFormatter stringFromNumber:number] length];
    currencyFormatter.formatWidth = count+1;
    return [currencyFormatter stringFromNumber:number];
}
@end
