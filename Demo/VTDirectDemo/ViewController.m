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
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UILabel *statusLabel;
    IBOutlet UITextField *emailTextField;
    
    NSArray *_items;
    VTUser *_user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _items = [self items];
    _user = [VTUser userWithFirstName:@"Nanang"
                             lastName:@"Rafsanjani"
                                email:@"jukiginanjar@yahoo.com"
                                phone:@"08985999286"
                      shippingAddress:nil
                       billingAddress:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkoutPressed:(UIBarButtonItem *)sender {
    VTPaymentViewController *vc = [VTPaymentViewController paymentWithUser:_user andItems:_items];
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

- (IBAction)payPressed:(UIButton *)sender {
    
    
    //    VTCartController *vc = [VTCartController cartWithItems:[self items]];
    //    [self presentViewController:vc animated:YES completion:nil];
    
    //    VTPaymentListController *vc = [VTPaymentListController paymentListWithPriceAmount:@50000];
    //    [self presentViewController:vc animated:YES completion:nil];
    
    //    VTAddCardController *vc = [VTAddCardController newController];
    //    [self presentViewController:vc animated:YES completion:nil];
    //
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"MidtransResources" ofType:@"bundle"];
    //    NSBundle *bundle = [NSBundle bundleWithPath:path];
    //    NSError *error;
    //    [bundle loadAndReturnError:&error];
    //    NSLog(@"%@", error);
    
    //    [indicatorView startAnimating];
    //    VTCreditCard *card = [VTCreditCard cardWithNumber:@4811111111111114
    //                                          expiryMonth:@1
    //                                           expiryYear:@2020
    //                                                saved:YES];
    //
    //    VTAddress *address = [VTAddress addressWithName:@"Jaka"
    //                                           lastName:@"Ginanjar"
    //                                              email:emailTextField.text
    //                                              phone:@"08985999286"
    //                                            address:@"Condong Catur"
    //                                               city:@"Yogyakarta"
    //                                         postalCode:@"54824"
    //                                        countryCode:@"IND"];
    //
    //    VTUser *user = [VTUser userWithFirstName:@"Jaka"
    //                                    lastName:@"Ginanjar"
    //                                       email:emailTextField.text
    //                                       phone:@"08985999286"
    //                             shippingAddress:address
    //                              billingAddress:address];
    //
    //    VTItem *item = [VTItem itemWithId:@"xyz"
    //                                 name:@"yakult"
    //                                price:@5000
    //                             quantity:@10];
    //
    //    VTPaymentCreditCard *payment = [VTPaymentCreditCard paymentWithCard:card
    //                                                                   bank:@"bni"
    //                                                                 secure:YES
    //                                                                   user:user
    //                                                                  items:@[item]];
    //
    //    [payment payWithCVV:@"123" callback:^(id response, NSError *error) {
    //        [indicatorView stopAnimating];
    //
    //        if (error) {
    //            statusLabel.text = [NSString stringWithFormat:@"Error %@", error.localizedDescription];
    //        } else {
    //            statusLabel.text = [NSString stringWithFormat:@"Success %@", response];
    //        }
    //    }];
}

@end
