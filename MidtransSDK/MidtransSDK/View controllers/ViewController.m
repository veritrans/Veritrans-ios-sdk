//
//  ViewController.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "ViewController.h"
#import "MIDClient.h"
#import "MIDCheckoutRequest.h"

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
    MIDTransaction *trans = [MIDTransaction modelWithOrderID:orderID grossAmount:@1000];
    MIDCheckoutRequest *req = [[MIDCheckoutRequest alloc] initWithTransaction:trans];
    [[MIDClient shared] checkoutWith:req completion:^(MIDToken * _Nullable token, NSError * _Nullable error) {
        [[MIDClient shared] fetchPaymentInformationWithToken:token.token completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error) {
            
        }];
    }];
}

@end
