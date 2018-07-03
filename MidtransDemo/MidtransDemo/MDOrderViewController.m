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
#import <ACFloatingTextfield_Objc/ACFloatingTextField.h>
#import <MidtransCoreKit/MidtransCoreKit.h>
#import <MidtransCoreKit/SNPFreeTextDataModels.h>
#import "MDOptionManager.h"
#import <MidtransKit/MidtransKit.h>
#import <JGProgressHUD/JGProgressHUD.h>

@interface MDOrderViewController () <MidtransUIPaymentViewControllerDelegate,MidtransPaymentWebControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIView *amountView;
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
    UICONFIG.hideStatusPage = NO;
    [[MidtransCreditCardConfig shared] setPaymentType:MTCreditCardPaymentTypeTwoclick];
    [MidtransCreditCardConfig shared].setDefaultCreditSaveCardEnabled = YES;
    [[MidtransCreditCardConfig shared] setSaveCardEnabled:TRUE];
    [[MidtransCreditCardConfig shared] setSecure3DEnabled:TRUE];
    [[MidtransCreditCardConfig shared] setTokenStorageEnabled:TRUE];
    [[MidtransUIConfiguration shared] setHideStatusPage:FALSE];
    [[MidtransNetworkLogger shared] startLogging];
    //CC_CONFIG.showFormCredentialsUser = YES;
    
    /*set custom free text for bca*/
    NSDictionary *inquiryConstructor=@{@"en":@"inquiry text in English",@"id":@"inquiry Text in ID"};
    NSDictionary *inquiryConstructor2=@{@"en":@"inquiry text in English",@"id":@"inquiry Text in ID"};
    NSDictionary *paymentConstructor=@{@"en":@"payment text in English",@"id":@"payment Text in ID"};
    
    NSDictionary *freeText = @{@"inquiry":@[inquiryConstructor,inquiryConstructor2],@"payment":@[paymentConstructor]};
    CONFIG.customFreeText = freeText;
    UICONFIG.hideStatusPage = NO;
    CONFIG.customPaymentChannels = [[MDOptionManager shared].paymentChannel.value valueForKey:@"type"];
    CONFIG.customBCAVANumber = [MDOptionManager shared].bcaVAOption.value;
    CONFIG.customBNIVANumber = [MDOptionManager shared].bniVAOption.value;
    CONFIG.customPermataVANumber = [MDOptionManager shared].permataVAOption.value;
    [[MidtransNetworkLogger shared] startLogging];
    
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
    
    MidtransCustomerDetails *cst = [[MidtransCustomerDetails alloc] initWithFirstName:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_FIRST_NAME"]
                                                                             lastName:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_LAST_NAME"]
                                                                                email:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_EMAIL"]
                                                                                phone:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_PHONE"]
                                                                      shippingAddress:addr
                                                                       billingAddress:addr];
    cst.customerIdentifier = @"3A8788CE-B96F-449C-8180-B5901A08B50A";
    MidtransItemDetail *itm = [[MidtransItemDetail alloc] initWithItemID:[NSString randomWithLength:20]
                                                                    name:@"Midtrans Pillow"
                                                                   price:@10000
                                                                quantity:@1];
    
    MidtransTransactionDetails *trx = [[MidtransTransactionDetails alloc] initWithOrderID:[NSString randomWithLength:20]
                                                                           andGrossAmount:@10000];
    
    //configure theme
    MidtransUIFontSource *font = [[MidtransUIFontSource alloc] initWithFontNameBold:@"SourceSansPro-Bold"
                                                                    fontNameRegular:@"SourceSansPro-Regular"
                                                                      fontNameLight:@"SourceSansPro-Light"];
    UIColor *color = [MDOptionManager shared].colorOption.value;
    [MidtransUIThemeManager applyCustomThemeColor:color themeFont:font];
    
    NSArray *binFilter = @[];
    NSArray *blacklistBin = @[];
    
    
    binFilter = @[@"4"];
    //configure expire time
    [[MidtransNetworkLogger shared] startLogging];
    
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
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"voucher":@"123",@"code":@"data"} // Here you can pass array or dictionary
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:&error];
//    NSString *jsonString;
//    if (jsonData) {
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        //This is your JSON String
//        //NSUTF8StringEncoding encodes special characters using an escaping scheme
//    } else {
//        NSLog(@"Got an error: %@", error);
//        jsonString = @"";
//    }
//    [arrayOfCustomField addObject:@{MIDTRANS_CUSTOMFIELD_1:jsonString}];
    
    [[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:trx
                                                                       itemDetails:@[itm]
                                                                   customerDetails:cst
                                                                       customField:arrayOfCustomField
                                                                         binFilter:binFilter
                                                                blacklistBinFilter:blacklistBin
                                                             transactionExpireTime:expireTime
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

- (IBAction)editAddressViewController:(id)sender {
    AddAddressViewController *addAddressVC = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
    [self.navigationController pushViewController:addAddressVC animated:YES];
}


@end
