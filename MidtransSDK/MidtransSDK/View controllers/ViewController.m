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
    NSDate *date = [NSDate new];
    NSString *orderID = [NSString stringWithFormat:@"%f", date.timeIntervalSince1970];
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:orderID grossAmount:@1000];
    
    
    [MIDClient checkoutWith:trx options:nil completion:^(MIDToken * _Nullable token, NSError * _Nullable error) {
        NSLog(@"Token: %@", token.dictionaryValue);
        
        [self fetchPaymentInfo:token.token];
        
        [self payWithToken:token.token];
    }];
}

- (void)fetchPaymentInfo:(NSString *)token {
    [MIDClient getPaymentInfoWithToken:token completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error) {
        NSLog(@"Payment info: %@", info.dictionaryValue);
    }];
}

- (void)payWithToken:(NSString *)token {
    [MIDEWalletCharge tcashWithToken:token
                         phoneNumber:@"0811111111"
                          completion:^(MIDPaymentResult * _Nullable result, NSError * _Nullable error)
     {
         NSLog(@"Charge result: %@", [result dictionaryValue]);
     }];
}

@end
