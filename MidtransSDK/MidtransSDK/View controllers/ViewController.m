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
    NSString *orderID = [NSString stringWithFormat:@"%f", [NSDate new].timeIntervalSince1970];
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:orderID grossAmount:@200000];
    
    MIDCheckoutIdentifier *identifier = [[MIDCheckoutIdentifier alloc] initWithUserIdentifier:@"jukiginanjar"];
    MIDCheckoutCreditCard *cc = [MIDCheckoutCreditCard new];
    cc.secure = YES;
    
    NSArray *terms = @[[MIDCheckoutInstallmentTerm modelWithBank:MIDAcquiringBankBCA terms:@[@3, @6]],
                       [MIDCheckoutInstallmentTerm modelWithBank:MIDAcquiringBankBNI terms:@[@6, @12]]
                       ];
    cc.installment = [MIDCheckoutInstallment modelWithTerms:terms required:YES];
    
    [MIDClient checkoutWith:trx
                    options:@[identifier, cc]
                 completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
     {
         NSLog(@"Token: %@", token.dictionaryValue);
         
         [self fetchPaymentInfo:token.token];
     }];
}

- (void)fetchPaymentInfo:(NSString *)token {
    [MIDClient getPaymentInfoWithToken:token completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error) {
        NSLog(@"Payment info: %@", info.dictionaryValue);
        
        [self payWithToken:token];
    }];
}

- (void)payWithToken:(NSString *)snapToken {
    //    NSString *savedToken = @"481111YsuAbkgTENXrcXGdqAssTN1114";
    //    [MIDCreditCardCharge chargeWithToken:snapToken
    //                               cardToken:savedToken
    //                                    save:YES
    //                             installment:nil
    //                                   point:nil
    //                              completion:^(MIDCreditCardResult * _Nullable result, NSError * _Nullable error)
    //     {
    //
    //     }];
    
    //    NSString *mandiriNumber = @"4617006959746656";
    NSString *bniNumber = @"4105058689481467";
    
    MIDTokenizeConfig *config = [MIDTokenizeConfig new];
    config.enable3ds = YES;
    config.enablePoint = YES;
    config.grossAmount = @200000;
    config.installmentTerm = 3;
    [MIDCreditCardTokenizer tokenizeCardNumber:bniNumber
                                           cvv:@"123"
                                   expireMonth:@"02"
                                    expireYear:@"20"
                                        config:config
                                    completion:^(MIDTokenizeResponse *_Nullable token, NSError * _Nullable error)
     {
         
//         [MIDCreditCardCharge getPointWithToken:snapToken
//                                      cardToken:token.tokenID
//                                     completion:^(MIDPointResponse *_Nullable result, NSError * _Nullable error)
//          {
//
//          }];
         
         [MIDCreditCardCharge chargeWithToken:snapToken
                                    cardToken:token.tokenID
                                         save:YES
                                  installment:[MIDChargeInstallment modelWithBank:MIDAcquiringBankBCA term:3]
                                        point:@20000
                                   completion:^(MIDCreditCardResult * _Nullable result, NSError * _Nullable error)
          {

          }];
     }];
    
}

@end
