//
//  PaymentListViewController.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "PaymentListViewController.h"
#import "MidtransUISDK.h"

@interface PaymentListViewController ()

@end

@implementation PaymentListViewController {
    NSArray *_payments;
    MIDCustomerDetails *customer;
    MIDCheckoutItems *checkoutItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MIDAddress *addr = [[MIDAddress alloc] initWithFirstName:@"susan"
                                                    lastName:@"bahtiar"
                                                       email:@"susan_bahtiar@gmail.com"
                                                       phone:@"08123456789"
                                                     address:@"Kemayoran"
                                                        city:@"Jakarta"
                                                  postalCode:@"10610"
                                                 countryCode:@"IDN"];
    customer = [[MIDCustomerDetails alloc] initWithFirstName:@"susan"
                                                    lastName:@"bahtiar"
                                                       email:@"susan_bahtiar@gmail.com"
                                                       phone:@"08123456789"
                                              billingAddress:addr
                                             shippingAddress:addr];
    MIDItem *item = [[MIDItem alloc] initWithID:@"item1"
                                          price:@20000
                                       quantity:1
                                           name:@"Tooth paste"
                                          brand:@"Pepsodent"
                                       category:@"Health care"
                                   merchantName:@"Neo Store"];
    checkoutItem = [[MIDCheckoutItems alloc] initWithItems:@[item]];
    
    _payments = @[@(MIDPaymentMethodBCAVA),
                  @(MIDPaymentMethodMandiriVA),
                  @(MIDPaymentMethodBNIVA),
                  @(MIDPaymentMethodPermataVA),
                  @(MIDPaymentMethodOtherVA),
                  @(MIDPaymentMethodKlikbca),
                  @(MIDPaymentMethodBCAKlikpay),
                  @(MIDPaymentMethodMandiriClickpay),
                  @(MIDPaymentMethodCIMBClicks),
                  @(MIDPaymentMethodDanamonOnline),
                  @(MIDPaymentMethodBRIEpay),
                  @(MIDPaymentMethodMandiriECash),
                  @(MIDPaymentMethodIndomaret),
                  @(MIDPaymentMethodAkulaku),
                  @(MIDPaymentMethodTelkomselCash),
                  @(MIDPaymentMethodGopay),
                  @(MIDPaymentMethodAlfamart),
                  @(MIDPaymentMethodCreditCard)
                  ];
}

- (NSString *)generateOrderID {
    return [[NSString stringWithFormat:@"%f", [NSDate new].timeIntervalSince1970] stringByReplacingOccurrencesOfString:@"." withString:@""];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _payments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payment_cell"];
    MIDPaymentMethod method = [_payments[indexPath.row] integerValue];
    cell.textLabel.text = [NSString stringOfPaymentMethod:method];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *orderID = [self generateOrderID];
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:orderID
                                                                      grossAmount:@20000
                                                                         currency:MIDCurrencyIDR];
    
    MIDPaymentMethod method = [_payments[indexPath.row] integerValue];
    
    NSMutableArray *options = [NSMutableArray arrayWithArray:@[customer, checkoutItem]];
    
    if (method == MIDPaymentMethodGopay) {
        MIDCheckoutGoPay *gopay = [[MIDCheckoutGoPay alloc] initWithCallbackSchemeURL:@"revamp.gopay://"];
        [options addObject:gopay];
    }
    
    //and put it at checkout options
    [MidtransKit presentPaymentPageAt:self
                          transaction:trx
                              options:options
                        paymentMethod:method];
}

@end
