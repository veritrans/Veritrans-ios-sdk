//
//  OptionViewController.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 3/15/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "OptionViewController.h"
#import "IHKeyboardAvoiding.h"
#import "FontListViewController.h"

#import <MidtransKit/MidtransUIPaymentViewController.h>
#import <MidtransCoreKit/MidtransConfig.h>
#import <MidtransCoreKit/MidtransMerchantClient.h>

#import <FCColorPickerViewController.h>

@interface OptionViewController () <FCColorPickerViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *ccOptionSegment;
@property (strong, nonatomic) IBOutlet UISwitch *secureSwitch;
@property (strong, nonatomic) IBOutlet UIView *shippingAddressView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *shippingAddressHeight;
@property (strong, nonatomic) IBOutlet UISwitch *sameAsBillingSwitch;
@property (strong, nonatomic) IBOutlet UIButton *chooseColorButton;
@property (strong, nonatomic) IBOutlet UIButton *chooseFontButton;

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

@property (nonatomic) MTCreditCardPaymentType ccPaymentType;
@property (nonatomic) BOOL cardSecure;

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *themeColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme_color"];
    UIColor *themeColor = [NSKeyedUnarchiver unarchiveObjectWithData:themeColorData];
    [self.chooseColorButton setBackgroundColor:themeColor];
    
    
    self.chooseColorButton.layer.cornerRadius = 5;
    self.chooseFontButton.layer.cornerRadius = 5;
    self.chooseFontButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.chooseFontButton.layer.borderWidth = 1.0f;
    
    self.cardSecure = [CC_CONFIG secure];
    self.ccPaymentType = [CC_CONFIG paymentType];
    
    self.secureSwitch.on = self.cardSecure;
    switch (self.ccPaymentType) {
        case MTCreditCardPaymentTypeNormal:
            self.ccOptionSegment.selectedSegmentIndex = 0;
            break;
        case MTCreditCardPaymentTypeTwoclick:
            self.ccOptionSegment.selectedSegmentIndex = 1;
            break;
        case MTCreditCardPaymentTypeOneclick:
            self.ccOptionSegment.selectedSegmentIndex = 2;
            break;
    }
    
    [IHKeyboardAvoiding setAvoidingView:_scrollView];
    
    NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"vt_customer"];
    MidtransCustomerDetails *customer = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    
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
    
    self.sameAsBillingSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"same_as_billing_address"] boolValue];
    [self updateShippingAddressView];
}

- (NSString *)countryCode {
    return @"IDN";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *fontNameBold;
    NSArray *fontNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"custom_font"];
    for (NSString *fontName in fontNames) {
        if ([fontName rangeOfString:@"-bold" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            fontNameBold = fontName;
        }
    }
    self.chooseFontButton.titleLabel.font = [UIFont fontWithName:fontNameBold size:self.chooseFontButton.titleLabel.font.pointSize];
    [self.chooseFontButton setTitle:fontNameBold forState:UIControlStateNormal];
}

- (void)updateShippingAddressView {
    if (self.sameAsBillingSwitch.on) {
        self.shippingAddressView.hidden = YES;
        self.shippingAddressHeight.constant = 0;
    }
    else {
        self.shippingAddressView.hidden = NO;
        self.shippingAddressHeight.constant = 260;
    }
}

- (IBAction)autoFillShippingAddressSwitchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:@"same_as_billing_address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateShippingAddressView];
    
    //scroll 
    [self.view layoutIfNeeded];
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
}

- (IBAction)chooseColorPressed:(UIButton *)sender {
    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPicker];
    colorPicker.color = sender.backgroundColor;
    colorPicker.delegate = self;
    [self presentViewController:colorPicker animated:YES completion:nil];
}

- (IBAction)chooseFontPressed:(UIButton *)sender {
    FontListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FontListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    MidtransAddress *billAddr = [MidtransAddress addressWithFirstName:_billFirstNameTextField.text
                                                             lastName:_billLastNameTextField.text
                                                                phone:_billPhoneTextField.text
                                                              address:_addressTextField.text
                                                                 city:_cityTextField.text
                                                           postalCode:_postCodeTextField.text
                                                          countryCode:[self countryCode]];
    MidtransAddress *shipAddr;
    
    if (self.sameAsBillingSwitch.on) {
        shipAddr = [MidtransAddress addressWithFirstName:billAddr.firstName
                                                lastName:billAddr.lastName
                                                   phone:billAddr.phone
                                                 address:billAddr.address
                                                    city:billAddr.city
                                              postalCode:billAddr.postalCode
                                             countryCode:billAddr.countryCode];
    }
    else {
        shipAddr = [MidtransAddress addressWithFirstName:_shipFirstNameTextField.text
                                                lastName:_shipLastNameTextField.text
                                                   phone:_shipPhoneTextField.text
                                                 address:_shipAddressTextField.text
                                                    city:_shipCityTextField.text
                                              postalCode:_shipPostCodeTextField.text
                                             countryCode:[self countryCode]];
    }
    
    MidtransCustomerDetails *customer = [[MidtransCustomerDetails alloc] initWithFirstName:_firstNameTextField.text lastName:_lastNameTextField.text email:_emailTextField.text phone:_phoneTextField.text shippingAddress:shipAddr billingAddress:billAddr];
    
    //save to NSUserDefaults
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:customer];
    [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:@"vt_customer"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.ccPaymentType) forKey:kOptionViewControllerCCType];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.cardSecure) forKey:kOptionViewControllerCCSecure];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MidtransCreditCardConfig setPaymentType:self.ccPaymentType secure:self.cardSecure];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)paymentTypeSegmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.ccPaymentType = MTCreditCardPaymentTypeNormal;
    }
    else if (sender.selectedSegmentIndex == 1) {
        self.ccPaymentType = MTCreditCardPaymentTypeTwoclick;
    }
    else if (sender.selectedSegmentIndex == 2) {
        self.ccPaymentType = MTCreditCardPaymentTypeOneclick;
    }
}

- (IBAction)secureSwitchChanged:(UISwitch *)sender {
    self.cardSecure = sender.on;
}

#pragma mark - FCColorPickerViewControllerDelegate Methods

-(void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"theme_color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.chooseColorButton setBackgroundColor:color];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
