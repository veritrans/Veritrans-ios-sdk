//
//  OptionViewController.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 3/15/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "OptionViewController.h"
#import "IHKeyboardAvoiding.h"

#import <MidtransKit/VTPaymentViewController.h>
#import <MidtransKit/VTCardControllerConfig.h>

#import <MidtransCoreKit/MidtransCoreKit.h>

@interface OptionViewController ()

@property (nonatomic) IBOutlet UISwitch *oneClickSwitch;
@property (nonatomic) IBOutlet UISwitch *secureSwitch;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;

@property (strong, nonatomic) IBOutlet UITextField *countryTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UITextField *postCodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *billFirstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *billLastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *billPhoneTextField;

@property (strong, nonatomic) IBOutlet UITextField *shipCountryTextField;
@property (strong, nonatomic) IBOutlet UITextField *shipCityTextField;
@property (strong, nonatomic) IBOutlet UITextField *shipPostCodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *shipAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *shipFirstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *shipLastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *shipPhoneTextField;

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_oneClickSwitch setOn:[[VTCardControllerConfig sharedInstance] enableOneClick]];
    [_secureSwitch setOn:[[VTCardControllerConfig sharedInstance] enable3DSecure]];
    
    [IHKeyboardAvoiding setAvoidingView:_scrollView];
    
    NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"vt_customer"];
    VTCustomerDetails *customer = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    
    _firstNameTextField.text = customer.firstName;
    _lastNameTextField.text = customer.lastName;
    _emailTextField.text = customer.email;
    _phoneTextField.text = customer.phone;
    
    _countryTextField.text = customer.billingAddress.countryCode;
    _cityTextField.text = customer.billingAddress.city;
    _postCodeTextField.text = customer.billingAddress.postalCode;
    _addressTextField.text = customer.billingAddress.address;
    _billFirstNameTextField.text = customer.billingAddress.firstName;
    _billLastNameTextField.text = customer.billingAddress.lastName;
    _billPhoneTextField.text = customer.billingAddress.phone;
    
    _shipAddressTextField.text = customer.shippingAddress.address;
    _shipCityTextField.text = customer.shippingAddress.city;
    _shipCountryTextField.text = customer.shippingAddress.countryCode;
    _shipFirstNameTextField.text = customer.shippingAddress.firstName;
    _shipLastNameTextField.text = customer.shippingAddress.lastName;
    _shipPhoneTextField.text = customer.shippingAddress.phone;
    _shipPostCodeTextField.text = customer.shippingAddress.postalCode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)countryCode {
    return @"IDN";
}

- (IBAction)resetMerchantAuth:(id)sender {
    [[VTMerchantClient sharedClient] fetchMerchantAuthDataWithCompletion:^(id response, NSError *error) {
        if (response) {
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"clientAuth"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[VTConfig sharedInstance] setMerchantClientData:response];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Reset merchant authentication success!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error loading merchant authentication data, please restart the App" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    VTAddress *shipAddr = [VTAddress addressWithFirstName:_shipFirstNameTextField.text lastName:_shipLastNameTextField.text phone:_shipPhoneTextField.text address:_shipAddressTextField.text city:_shipCityTextField.text postalCode:_shipPostCodeTextField.text countryCode:[self countryCode]];
    VTAddress *billAddr = [VTAddress addressWithFirstName:_billFirstNameTextField.text lastName:_billLastNameTextField.text phone:_billPhoneTextField.text address:_addressTextField.text city:_cityTextField.text postalCode:_postCodeTextField.text countryCode:[self countryCode]];
    VTCustomerDetails *customer = [[VTCustomerDetails alloc] initWithFirstName:_firstNameTextField.text lastName:_lastNameTextField.text email:_emailTextField.text phone:_phoneTextField.text shippingAddress:shipAddr billingAddress:billAddr];
    
    //save to NSUserDefaults
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:customer];
    [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:@"vt_customer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)oneClickSwitchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:@"enable_oneclick"];
    [[VTCardControllerConfig sharedInstance] setEnableOneClick:sender.on];
}

- (IBAction)secureSwitchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:@"enable_3ds"];
    [[VTCardControllerConfig sharedInstance] setEnable3DSecure:sender.on];
}

@end
