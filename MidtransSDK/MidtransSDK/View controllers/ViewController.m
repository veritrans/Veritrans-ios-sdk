//
//  ViewController.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "ViewController.h"
#import "MidtransSDK.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSString *snapToken;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)checkoutPressed:(id)sender {
//    NSDictionary *terms = @{@"bni": @[@3, @6, @12],
//                            @"mandiri": @[@3, @6],
//                            @"cimb": @[@3],
//                            @"offline": @[@6, @12]
//                            };
//    NSArray *whitelistBins = @[@"48111111",
//                               @"41111111",
//                               @"bni"
//                               ];
//    MIDCheckoutInstallment *installment = [[MIDCheckoutInstallment alloc] initWithTerms:terms required:NO];
//    MIDCheckoutCreditCard *cc = [[MIDCheckoutCreditCard alloc] initWithTransactionType:MIDCreditCardTransactionTypeAuthorizeCapture
//                                                                          enableSecure:NO
//                                                                        enableSaveCard:NO
//                                                                         acquiringBank:MIDAcquiringBankNone
//                                                                      acquiringChannel:MIDAcquiringChannelNone
//                                                                           installment:installment
//                                                                         whiteListBins:whitelistBins];
//
//    MIDCheckoutCustomer *customer = [[MIDCheckoutCustomer alloc] initWithFirstName:@"Nanang"
//                                                                          lastName:@"Rafsanjani"
//                                                                             email:nil
//                                                                             phone:nil
//                                                                    billingAddress:nil
//                                                                   shippingAddress:nil];
    
    MIDCheckoutGoPay *gopay = [[MIDCheckoutGoPay alloc] initWithCallbackSchemeURL:@"demo.midtrans"];
    
    NSDate *date = [NSDate new];
    NSString *orderID = [NSString stringWithFormat:@"%f", date.timeIntervalSince1970];
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:orderID grossAmount:@1000];
    
    [[MIDClient shared] checkoutWith:trx options:@[gopay] completion:^(MIDToken * _Nullable token, NSError * _Nullable error) {
        NSLog(@"Token: %@", token.dictionaryValue);
        
        [self fetchPaymentInfo:token.token];
        
        [self payWithToken:token.token];
    }];
}

- (void)fetchPaymentInfo:(NSString *)token {
    [[MIDClient shared] getPaymentInfoWithToken:token completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error) {
        NSLog(@"Payment info: %@", info.dictionaryValue);
    }];
}

- (void)payWithToken:(NSString *)token {
//    MIDVirtualAccountPayment *payment = [[MIDVirtualAccountPayment alloc] initWithType:MIDVirtualAccountTypeBCA email:nil];
//    MIDVirtualAccountPayment *payment = [[MIDVirtualAccountPayment alloc] initWithType:MIDVirtualAccountTypeEchannel email:nil];
//    MIDVirtualAccountPayment *payment = [[MIDVirtualAccountPayment alloc] initWithType:MIDVirtualAccountTypePermata email:nil];
    MIDVirtualAccountPayment *payment = [[MIDVirtualAccountPayment alloc] initWithType:MIDVirtualAccountTypeBNI email:nil];
    
    [[MIDClient shared] performPayment:payment token:token completion:^(MIDPaymentResult * _Nullable result, NSError * _Nullable error) {
        NSLog(@"Payment result: %@", result.dictionaryValue);
    }];
}

@end
