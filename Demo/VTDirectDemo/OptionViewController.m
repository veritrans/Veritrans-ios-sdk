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
#import "AcquiringBankTableViewController.h"

#import <MidtransKit/MidtransUIPaymentViewController.h>
#import <MidtransCoreKit/MidtransConfig.h>
#import <MidtransCoreKit/MidtransMerchantClient.h>

#import <FCColorPickerViewController.h>

@interface OptionViewController () <FCColorPickerViewControllerDelegate, AcquiringBankTableViewControllerDelegate, FontListViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *ccOptionSegment;
@property (strong, nonatomic) IBOutlet UISwitch *secureSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *tokenStorageSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *saveCardSwitch;
@property (strong, nonatomic) IBOutlet UIView *shippingAddressView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *shippingAddressHeight;
@property (strong, nonatomic) IBOutlet UISwitch *sameAsBillingSwitch;
@property (strong, nonatomic) IBOutlet UIButton *chooseColorButton;
@property (strong, nonatomic) IBOutlet UIButton *chooseFontButton;
@property (strong, nonatomic) IBOutlet UIButton *acquiringBankButton;
@property (strong, nonatomic) IBOutlet UISwitch *promoEngineSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *preauthSwitch;

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

@property (nonatomic) UIColor *themeColor;
@property (nonatomic) NSArray *fontNames;
@property (nonatomic) id acquiringBank;
@property (nonatomic, assign) BOOL promoEngineEnabled;
@property (nonatomic, assign) BOOL preauthEnabled;

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    
    NSData *themeColorData = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerThemeColor];
    self.themeColor = [NSKeyedUnarchiver unarchiveObjectWithData:themeColorData];
    if (!self.themeColor) {
        //default color
        self.themeColor = [UIColor colorWithRed:25/255. green:163/255. blue:239/255. alpha:1];
    }
    [self.chooseColorButton setBackgroundColor:self.themeColor];
    self.chooseColorButton.layer.cornerRadius = 5;
    self.chooseColorButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.chooseColorButton.layer.borderWidth = 1.0f;
    
    self.fontNames = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCustomFont];
    if (!self.fontNames) {
        //default fonts
        self.fontNames = @[@"SourceSansPro-Regular", @"SourceSansPro-Bold", @"SourceSansPro-Lignt", @"SourceSansPro-Semibold"];
    }
    
    UIFont *font = [self fontFromFamilyNames:self.fontNames];
    self.chooseFontButton.titleLabel.font = font;
    [self.chooseFontButton setTitle:font.familyName forState:UIControlStateNormal];
    self.chooseFontButton.layer.cornerRadius = 5;
    self.chooseFontButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.chooseFontButton.layer.borderWidth = 1.0f;
    self.chooseFontButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    
    self.acquiringBank = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionViewControllerCCAcquiringBank];
    if (!self.acquiringBank) {
        self.acquiringBank = @{@"type":@(MTAcquiringBankMandiri), @"string":@"Mandiri"};
    }
    [self.acquiringBankButton setTitle:self.acquiringBank[@"string"] forState:UIControlStateNormal];
    self.acquiringBankButton.layer.cornerRadius = 5;
    self.acquiringBankButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.acquiringBankButton.layer.borderWidth = 1.0f;
    self.acquiringBankButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    
    self.secureSwitch.on = CC_CONFIG.secure3DEnabled;
    self.tokenStorageSwitch.on = CC_CONFIG.tokenStorageEnabled;
    self.saveCardSwitch.on = CC_CONFIG.saveCardEnabled;
    self.ccOptionSegment.selectedSegmentIndex = CC_CONFIG.paymentType;
    
    [IHKeyboardAvoiding setAvoidingView:_scrollView];
    
    self.promoEngineSwitch.on = CC_CONFIG.promoEnabled;
    self.promoEngineEnabled = CC_CONFIG.promoEnabled;
    
    self.preauthSwitch.on = CC_CONFIG.preauthEnabled;
    self.preauthEnabled = CC_CONFIG.preauthEnabled;
    
    NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"vt_customer"];
    MidtransCustomerDetails *customer = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    
    _firstNameTextField.text = customer.firstName;
    _firstNameTextField.tag = 1;
    _firstNameTextField.delegate = self;
    
    _lastNameTextField.text = customer.lastName;
    _lastNameTextField.tag = 2;
    _lastNameTextField.delegate = self;
    
    _emailTextField.text = customer.email;
    _emailTextField.tag = 3;
    _emailTextField.delegate = self;
    
    _phoneTextField.text = customer.phone;
    _phoneTextField.tag = 4;
    _phoneTextField.delegate = self;
    
    _countryTextField.text = customer.billingAddress.countryCode;
    _countryTextField.tag = 4;
    _countryTextField.delegate = self;
    
    _cityTextField.text = customer.billingAddress.city;
    _cityTextField.tag = 5;
    _cityTextField.delegate = self;
    
    _postCodeTextField.text = customer.billingAddress.postalCode;
    _postCodeTextField.tag = 6;
    _postCodeTextField.delegate = self;
    
    _addressTextField.text = customer.billingAddress.address;
    _addressTextField.tag = 7;
    _addressTextField.delegate = self;
    
    _billFirstNameTextField.text = customer.billingAddress.firstName;
    _billFirstNameTextField.tag = 8;
    _billFirstNameTextField.delegate = self;
    
    _billLastNameTextField.text = customer.billingAddress.lastName;
    _billLastNameTextField.tag = 9;
    _billLastNameTextField.delegate = self;
    
    _billPhoneTextField.text = customer.billingAddress.phone;
    _billPhoneTextField.tag = 10;
    _billPhoneTextField.delegate = self;
    
    _shipAddressTextField.text = customer.shippingAddress.address;
    _shipAddressTextField.tag = 11;
    _shipAddressTextField.delegate = self;
    
    _shipCityTextField.text = customer.shippingAddress.city;
    _shipCityTextField.tag = 12;
    _shipCityTextField.delegate = self;
    
    _shipCountryTextField.text = customer.shippingAddress.countryCode;
    _shipCountryTextField.tag = 13;
    _shipCountryTextField.delegate = self;
    
    _shipFirstNameTextField.text = customer.shippingAddress.firstName;
    _shipFirstNameTextField.tag = 14;
    _shipFirstNameTextField.delegate = self;
    
    _shipLastNameTextField.text = customer.shippingAddress.lastName;
    _shipLastNameTextField.tag = 15;
    _shipLastNameTextField.delegate = self;
    
    _shipPhoneTextField.text = customer.shippingAddress.phone;
    _shipPhoneTextField.tag = 16;
    _shipPhoneTextField.delegate = self;
    
    _shipPostCodeTextField.text = customer.shippingAddress.postalCode;
    _shipPostCodeTextField.tag = 17;
    _shipPostCodeTextField.delegate = self;
    
    self.sameAsBillingSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"same_as_billing_address"] boolValue];
    [self updateShippingAddressView];
}

- (void)closePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)countryCode {
    return @"IDN";
}

- (void)updateShippingAddressView {
    if (self.sameAsBillingSwitch.on) {
        self.shippingAddressHeight.constant = 0;
    }
    else {
        self.shipFirstNameTextField.text = nil;
        self.shipLastNameTextField.text = nil;
        self.shipPhoneTextField.text = nil;
        self.shipCountryTextField.text = nil;
        self.shipCityTextField.text = nil;
        self.shipPostCodeTextField.text = nil;
        self.shipAddressTextField.text = nil;
        
        self.shippingAddressHeight.constant = 260;
    }
    
    [self.scrollView layoutIfNeeded];
}

- (IBAction)autoFillShippingAddressSwitchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:@"same_as_billing_address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateShippingAddressView];
    
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
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)acquiringBankPressed:(UIButton *)sender {
    AcquiringBankTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AcquiringBankTableViewController"];
    vc.delegate = self;
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
    
    [[NSUserDefaults standardUserDefaults] setObject:@(CC_CONFIG.paymentType) forKey:kOptionViewControllerCCType];
    [[NSUserDefaults standardUserDefaults] setObject:@(CC_CONFIG.secure3DEnabled) forKey:kOptionViewControllerCCSecure];
    [[NSUserDefaults standardUserDefaults] setObject:@(CC_CONFIG.tokenStorageEnabled) forKey:kOptionViewControllerCCTokenStorage];
    [[NSUserDefaults standardUserDefaults] setObject:@(CC_CONFIG.saveCardEnabled) forKey:kOptionViewControllerCCSaveCard];
    
    CC_CONFIG.promoEnabled = self.promoEngineEnabled;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.promoEngineEnabled) forKey:kOptionViewControllerPromoEngine];
    
    CC_CONFIG.preauthEnabled = self.preauthEnabled;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.preauthEnabled) forKey:kOptionViewControllerPreauth];
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:self.themeColor];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kOptionViewControllerThemeColor];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.fontNames forKey:kOptionViewControllerCustomFont];
    
    CC_CONFIG.acquiringBank = [self.acquiringBank[@"type"] integerValue];
    [[NSUserDefaults standardUserDefaults] setObject:self.acquiringBank forKey:kOptionViewControllerAcquiringBank];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)paymentTypeSegmentChanged:(UISegmentedControl *)sender {
    CC_CONFIG.paymentType = sender.selectedSegmentIndex;
}

- (IBAction)secureSwitchChanged:(UISwitch *)sender {
    CC_CONFIG.secure3DEnabled = sender.on;
}
- (IBAction)promoEngineSwitchChanged:(UISwitch *)sender {
    self.promoEngineEnabled = sender.on;
}

- (IBAction)tokenStorageSwitchChanged:(UISwitch *)sender {
    CC_CONFIG.tokenStorageEnabled = sender.on;
}

- (IBAction)saveCardSwitchChanged:(UISwitch *)sender {
    CC_CONFIG.saveCardEnabled = sender.on;
}
- (IBAction)preauthChanged:(UISwitch *)sender {
    self.preauthEnabled = sender.on;
}

#pragma mark - Helper

- (UIFont *)fontFromFamilyNames:(NSArray *)fontFamilyNames {
    for (NSString *fontName in fontFamilyNames) {
        if ([fontName rangeOfString:@"-regular" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return [UIFont fontWithName:fontName size:self.chooseFontButton.titleLabel.font.pointSize];
        }
    }
    return nil;
}

#pragma mark - FCColorPickerViewControllerDelegate Methods

-(void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    self.themeColor = color;
    [self.chooseColorButton setBackgroundColor:color];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AcquiringBankTableViewControllerDelegate

- (void)didSelectAcquiringBank:(NSDictionary *)acquiringBank {
    if (acquiringBank) {
        self.acquiringBank = acquiringBank;
        [self.acquiringBankButton setTitle:acquiringBank[@"string"] forState:UIControlStateNormal];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FontListViewControllerDelegate

- (void)didSelectFontNames:(NSArray *)fontNames {
    if (fontNames) {
        UIFont *font = [self fontFromFamilyNames:fontNames];
        self.chooseFontButton.titleLabel.font = font;
        [self.chooseFontButton setTitle:font.familyName forState:UIControlStateNormal];
        
        self.fontNames = fontNames;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
