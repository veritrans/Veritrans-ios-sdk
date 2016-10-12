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


@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray <VTItemDetail*>* itemDetails;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.itemDetails = [self generateItemDetails];
    
    self.navigationController.view.userInteractionEnabled = NO;
    NSDictionary *clientAuth = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientAuth"];
    if (clientAuth) {
        [CONFIG setMerchantClientData:clientAuth];
        self.navigationController.view.userInteractionEnabled = YES;
    }
    else {
        [[VTMerchantClient sharedClient] fetchMerchantAuthDataWithCompletion:^(id response, NSError *error) {
            if (response) {
                [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"clientAuth"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [CONFIG setMerchantClientData:response];
                self.navigationController.view.userInteractionEnabled = YES;
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error loading merchant authentication data, please restart the App" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionSuccess:) name:VTTransactionDidSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionFailed:) name:VTTransactionDidFailed object:nil];
}

- (IBAction)settingPressed:(UIBarButtonItem *)sender {
    OptionViewController *option = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    [self.navigationController pushViewController:option animated:YES];
}

- (IBAction)checkoutPressed:(UIBarButtonItem *)sender {
    
    NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"vt_customer"];
    VTCustomerDetails *customerDetails = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    VTTransactionDetails *transactionDetails = [[VTTransactionDetails alloc] initWithOrderID:[NSString randomWithLength:20] andGrossAmount:[self grossAmountOfItemDetails:self.itemDetails]];
    
    if (customerDetails) {
        
        VTCardListController *vc = [[VTCardListController alloc] initWithCustomerDetails:customerDetails itemDetails:self.itemDetails transactionDetails:transactionDetails];
        [vc presentOnViewController:self];
        
        //        [[VTCardControllerConfig sharedInstance] setEnableOneClick:YES];
        //        [[VTCardControllerConfig sharedInstance] setEnable3DSecure:YES];
        //
        //        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        //        f.numberStyle = NSNumberFormatterDecimalStyle;
        //        NSNumber *productPriceNumber = [f numberFromString:@"100000"];
        //        NSNumber *quantityNumber = [f numberFromString:@"1"];
        //        // itemDetail is an item for sale
        //        VTItemDetail *itemDetail = [[VTItemDetail alloc] initWithItemID:quantityNumber name:@"ayopop" price:productPriceNumber quantity:quantityNumber];
        //
        //        VTAddress *shipAddr = [VTAddress addressWithFirstName:@"Guru" lastName:@"Test" phone:@"1234567890" address:@"Test" city:@"Test" postalCode:@"Test" countryCode:@"Test"];
        //
        //        VTAddress *billAddr = [VTAddress addressWithFirstName:@"Guru" lastName:@"Test" phone:@"1234567890" address:@"Test" city:@"Test" postalCode:@"Test" countryCode:@"Test"];
        //
        //        // customerDetails is customer object
        //        VTCustomerDetails *customerDetails = [[VTCustomerDetails alloc] initWithFirstName:@"Guru" lastName:@"Test" email:@"gaurang@ayopop.com" phone:@"1234567890" shippingAddress:shipAddr billingAddress:billAddr];
        //
        //        // transactionDetails is the detail of transaction including the orderID and gross amount
        //        VTTransactionDetails *transactionDetails = [[VTTransactionDetails alloc] initWithOrderID:quantityNumber andGrossAmount:productPriceNumber];
        //
        //        VTPaymentViewController *vc = [[VTPaymentViewController alloc] initWithCustomerDetails:customerDetails itemDetails:@[itemDetail] transactionDetails:transactionDetails];
        //        vc.delegate = self;
        //        [self presentViewController:vc animated:YES completion:nil];
        
    } else {
        OptionViewController *option = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        [self.navigationController pushViewController:option animated:YES];
    }
}

#pragma mark - VTPaymentViewControllerDelegate

- (void)transactionSuccess:(NSNotification *)sender {
    VTTransactionResult *result = sender.userInfo[VT_TRANSACTION_RESULT];
    NSLog(@"success: %@", result);
}

- (void)transactionFailed:(NSNotification *)sender {
    NSError *error = sender.userInfo[VT_TRANSACTION_ERROR];
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
