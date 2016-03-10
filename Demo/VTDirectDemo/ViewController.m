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
#import <MidtransCoreKit/VTCustomerDetails.h>

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
    _customer = [[VTCustomerDetails alloc] initWithFirstName:@"Nanang" lastName:@"Rafsanjani" email:@"jukiginanjar@yahoo.com" phone:@"08985999286"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkoutPressed:(UIBarButtonItem *)sender {
    VTPaymentViewController *vc = [VTPaymentViewController controllerWithCustomer:_customer andItems:_items];
    [self presentViewController:vc animated:YES completion:nil];
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
