//
//  ViewController.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "ViewController.h"
#import "MidtransSDK.h"
#import "MidtransUISDK.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSString *snapToken;
}

- (IBAction)checkoutPressed:(id)sender {
    NSString *orderID = [[NSString stringWithFormat:@"%f", [NSDate new].timeIntervalSince1970] stringByReplacingOccurrencesOfString:@"." withString:@""];
    MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:orderID
                                                                      grossAmount:@20000
                                                                         currency:MIDCurrencyIDR];
    
    MIDCheckoutIdentifier *identifier = [[MIDCheckoutIdentifier alloc] initWithUserIdentifier:@"jukiginanjar"];
    
    NSArray *whitelistBins = @[@"48111111", @"41111111"];
    NSArray *blacklistBins = @[@"49111111", @"44111111"];
    MIDInstallmentTerm *term = [[MIDInstallmentTerm alloc] initWithBank:MIDAcquiringBankBCA
                                                                  terms:@[@6, @12]];
    MIDInstallment *installment = [[MIDInstallment alloc] initWithTerms:@[term] required:YES];
    MIDCreditCard *cc = [[MIDCreditCard alloc] initWithCreditCardTransactionType:MIDCreditCardTransactionTypeAuthorizeCapture
                                                                  authentication:MIDAuthenticationNone
                                                                   acquiringBank:MIDAcquiringBankNone
                                                                acquiringChannel:MIDAcquiringChannelNone
                                                                     installment:installment
                                                                   whiteListBins:nil
                                                                   blackListBins:nil];
    
    MIDAddress *addr = [[MIDAddress alloc] initWithFirstName:@"susan"
                                                    lastName:@"bahtiar"
                                                       email:@"susan_bahtiar@gmail.com"
                                                       phone:@"08123456789"
                                                     address:@"Kemayoran"
                                                        city:@"Jakarta"
                                                  postalCode:@"10610"
                                                 countryCode:@"IDN"];
    MIDCustomerDetails *customer = [[MIDCustomerDetails alloc] initWithFirstName:@"susan"
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
    MIDCheckoutItems *checkoutItem = [[MIDCheckoutItems alloc] initWithItems:@[item]];
    
    MIDCheckoutGoPay *gopay = [[MIDCheckoutGoPay alloc] initWithCallbackSchemeURL:@"yoururlscheme://"];
    
    MIDCheckoutExpiry *expiry = [[MIDCheckoutExpiry alloc] initWithStartDate:[NSDate date]
                                                                    duration:1
                                                                        unit:MIDExpiryTimeUnitDay];
    
    //and put it at checkout options
    [MidtransKit presentPaymentPageAt:self
                          transaction:trx
                              options:@[customer, checkoutItem]
                        paymentMethod:MIDPaymentMethodUnknown];
    
//        [MIDClient checkoutWith:trx
//                        options:@[customer, checkoutItem]
//                     completion:^(MIDToken *_Nullable token, NSError *_Nullable error)
//         {
//             NSString *snapToken = token.token;
//             NSLog(@"Token: %@", token.dictionaryValue);
//
//             [self fetchPaymentInfo:token.token];
//         }];
}

- (void)fetchPaymentInfo:(NSString *)token {
    [MIDClient getPaymentInfoWithToken:token completion:^(MIDPaymentInfo *_Nullable info, NSError *_Nullable error) {
        NSLog(@"Payment info: %@", info.dictionaryValue);
        
        [self payWithToken:token];
    }];
}

- (void)payWithToken:(NSString *)snapToken {
    [MIDEWalletCharge telkomselCashWithToken:snapToken
                                    customer:@"0811111111"
                                  completion:^(MIDTelkomselCashResult * _Nullable result, NSError * _Nullable error)
     {
         
     }];
    
    //    NSString *savedToken = @"481111YsuAbkgTENXrcXGdqAssTN1114";
    //    [MIDCreditCardCharge chargeWithToken:snapToken
    //                               cardToken:savedToken
    //                                    save:YES
    //                             installment:nil
    //                                   point:nil
    //                              completion:^(MIDCreditCardResult *_Nullable result, NSError *_Nullable error)
    //     {
    //
    //     }];
    
    //    NSString *mandiriNumber = @"4617006959746656";
    //        NSString *bniNumber = @"4105058689481467";
//    NSString *cardNumber = @"4811111111111114";
//
//    MIDTokenizeConfig *config = [MIDTokenizeConfig new];
//    config.enable3ds = YES;
//    //    config.enablePoint = YES;
//    config.grossAmount = @20000;
//    config.installmentTerm = 6;
//    [MIDCreditCardTokenizer tokenizeCardNumber:cardNumber
//                                           cvv:@"123"
//                                   expireMonth:@"02"
//                                    expireYear:@"20"
//                                        config:config
//                                    completion:^(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error)
//     {
//
//         //         [MIDCreditCardCharge getPointWithToken:snapToken
//         //                                      cardToken:token.tokenID
//         //                                     completion:^(MIDPointResponse *_Nullable result, NSError *_Nullable error)
//         //          {
//         //
//         //          }];
//
//         [MIDCreditCardCharge chargeWithToken:snapToken
//                                    cardToken:token.tokenID
//                                         save:YES
//                                  installment:[[MIDChargeInstallment alloc] initWithBank:MIDAcquiringBankBCA term:6]
//                                        point:nil//@20000
//                                   completion:^(MIDCreditCardResult *_Nullable result, NSError *_Nullable error)
//          {
//
//          }];
//     }];
//
//    [MIDBankTransferCharge bcaWithToken:snapToken
//                                   name:@"susan"
//                                  email:@"susan_bahtiar@gmail.com"
//                                  phone:@"085223768857"
//                             completion:^(MIDBCABankTransferResult * _Nullable result, NSError * _Nullable error)
//     {
//
//     }];
//
//    [MIDBankTransferCharge permataWithToken:snapToken
//                                       name:@"susan"
//                                      email:@"susan_bahtiar@gmail.com"
//                                      phone:@"085223768857"
//                                 completion:^(MIDPermataBankTransferResult * _Nullable result, NSError * _Nullable error)
//     {
//
//     }];
//
//    [MIDBankTransferCharge bniWithToken:snapToken
//                                   name:@"susan"
//                                  email:@"susan_bahtiar@gmail.com"
//                                  phone:@"085223768857"
//                             completion:^(MIDBNIBankTransferResult * _Nullable result, NSError * _Nullable error)
//     {
//
//     }];
//
//    [MIDBankTransferCharge mandiriWithToken:snapToken
//                                       name:@"susan"
//                                      email:@"susan_bahtiar@gmail.com"
//                                      phone:@"085223768857"
//                                 completion:^(MIDMandiriBankTransferResult * _Nullable result, NSError * _Nullable error)
//     {
//
//     }];
//
//    [MIDBankTransferCharge otherBankWithToken:snapToken
//                                         name:@"susan"
//                                        email:@"susan_bahtiar@gmail.com"
//                                        phone:@"085223768857"
//                                   completion:^(id _Nullable result, NSError * _Nullable error)
//     {
//
//     }];
}

@end
