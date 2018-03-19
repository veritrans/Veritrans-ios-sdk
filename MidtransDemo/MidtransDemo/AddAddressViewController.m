//
//  AddAddressViewController.m
//  MidtransDemo
//
//  Created by Vanbungkring on 12/19/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "AddAddressViewController.h"
#import <ACFloatingTextfield_Objc/ACFloatingTextField.h>
@interface AddAddressViewController ()
@property (weak, nonatomic) IBOutlet ACFloatingTextField *addressTextField;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *cityAddressTextField;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *postalCodeTextField;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *countryTextField;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Delivery Address";
    self.addressTextField.text  = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_ADDRESS"];
    self.cityAddressTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_CITY"];
    self.postalCodeTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_POSTAL_CODE"];
     self.countryTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DEMO_CONTENT_COUNTRY"];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)updateAddressButtonDidTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.addressTextField.text forKey:@"USER_DEMO_CONTENT_ADDRESS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:self.cityAddressTextField.text forKey:@"USER_DEMO_CONTENT_CITY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:self.postalCodeTextField.text forKey:@"USER_DEMO_CONTENT_POSTAL_CODE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:self.countryTextField.text forKey:@"USER_DEMO_CONTENT_COUNTRY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
