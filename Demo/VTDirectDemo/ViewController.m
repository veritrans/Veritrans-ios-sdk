//
//  ViewController.m
//  VTDirectDemo
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "ViewController.h"
#import <MidtransKit/VTPaymentViewController.h>
#import "TableViewCell.h"

#import <MidtransCoreKit/VTMandiriClickpay.h>
#import <MidtransCoreKit/VTItem.h>
#import <MidtransCoreKit/VTConfig.h>
#import <MidtransCoreKit/VTCustomerDetails.h>
#import <MidtransCoreKit/VTMerchantClient.h>

#import "OptionViewController.h"

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
@end

@implementation ViewController {
    NSArray *_items;
    VTCustomerDetails *_customer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _items = [self items];
    
    self.navigationController.view.userInteractionEnabled = NO;
    
    if ([CONFIG merchantAuth]) {
        self.navigationController.view.userInteractionEnabled = YES;
    } else {
        [[VTMerchantClient sharedClient] fetchMerchantAuthDataWithCompletion:^(id response, NSError *error) {
            VTMerchantAuth *merchantAuth = [[VTMerchantAuth alloc] initWithAuthData:response];
            [CONFIG setMerchantAuth:merchantAuth];
            
            self.navigationController.view.userInteractionEnabled = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingPressed:(UIBarButtonItem *)sender {
    OptionViewController *option = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    [self.navigationController pushViewController:option animated:YES];
}

- (IBAction)checkoutPressed:(UIBarButtonItem *)sender {
    NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"vt_customer"];
    VTCustomerDetails *customer = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    
    if (customer) {
        VTPaymentViewController *vc = [VTPaymentViewController controllerWithCustomer:customer andItems:_items];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        OptionViewController *option = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        [self.navigationController pushViewController:option animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    cell.item = _items[indexPath.row];
    return cell;
}

- (NSArray *)items {
    NSMutableArray *result = [NSMutableArray new];
    for (int i=0; i<6; i++) {
        VTItem *item = [VTItem itemWithId:[NSString randomWithLength:4] name:[NSString stringWithFormat:@"Item %i", i] price:@10000 imageURL:@"http://ecx.images-amazon.com/images/I/41kaolKUqdL._AA160_.jpg" quantity:@3];
        [result addObject:item];
    }
    return result;
}

@end
