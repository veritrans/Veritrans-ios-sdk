//
//  VTPaymentCreditCard.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCPaymentCreditCard.h"
#import "VTNetworking.h"
#import "VTConfig.h"
#import "VTWebViewController.h"
#import "VTHelper.h"

@interface VTCPaymentCreditCard() <VTWebViewControllerDelegate>
@property (nonatomic, readwrite) VTCreditCard *creditCard;
@property (nonatomic, readwrite) NSString *tokenId;
@property (nonatomic, strong) VTWebViewController *webTransViewController;
@property (nonatomic, copy) void (^tokenCallback)(id response, NSError *error);
@end

@implementation VTCPaymentCreditCard

#pragma mark - Public

+ (instancetype)paymentWithUser:(VTUser *)user amount:(NSNumber *)amount creditCard:(VTCreditCard *)creditCard {
    VTCPaymentCreditCard *payment = [[VTCPaymentCreditCard alloc] initWithUser:user amount:amount];
    payment.creditCard = creditCard;
    return payment;
}

- (void)payWithCVV:(NSString *)cvv callback:(void (^)(id, NSError *))callback {
    [self getTokenWithCVV:cvv callback:^(id response, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        } else {
            [self chargeWithCallback:callback];
        }
    }];
}

#pragma mark - Private

- (void)getTokenWithCVV:(NSString *)cvv callback:(void(^)(id response, NSError *error))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] baseUrl], @"token"];
    NSDictionary *param = @{@"client_key":[[VTConfig sharedInstance] clientKey],
                            @"card_number":_creditCard.number,
                            @"card_exp_month":_creditCard.expiryMonth,
                            @"card_exp_year":_creditCard.expiryYear,
                            @"card_type":_creditCard.type,
                            @"card_cvv":cvv,
                            @"secure":self.secure?@"true":@"false",
                            @"bank":self.bank,
                            @"gross_amount":self.amount
                            };
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:param callback:^(id response, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        } else {
            //set token id
            __weak VTCPaymentCreditCard *wself = self;
            wself.tokenId = response[@"token_id"];
            
            //set callback
            self.tokenCallback = callback;
            
            //present 3ds dialogue
            if (!self.webTransViewController) {
                self.webTransViewController = [[VTWebViewController alloc] init];
            }
            self.webTransViewController.webDelegate = self;
            self.webTransViewController.webUrl = [NSURL URLWithString:response[@"redirect_url"]];
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window.rootViewController presentViewController:self.webTransViewController animated:YES completion:nil];
        }
    }];
}

- (NSDictionary *)creditCardRequestData {
    return @{@"token_id":self.tokenId,
             @"bank":self.bank,
             @"save_token_id":_creditCard.saved ? @"true":@"false"};
}

- (void)chargeWithCallback:(void(^)(id response, NSError *error))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] merchantServerURL], @"charge"];
    NSDictionary *parameter = @{@"payment_type":@"credit_card",
                                @"credit_card":[self creditCardRequestData],
                                @"transaction_details":[self transactionDetail],
                                @"customer_details":[self.user customerDetails],
                                @"item_details":[self.items itemsRequestData]};
    
    [[VTNetworking sharedInstance] postToURL:URL parameters:parameter callback:callback];
}

#pragma mark - VTWebViewControllerDelegate

- (void)viewController_didFinishTransaction:(VTWebViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.tokenCallback) {
        self.tokenCallback(nil, nil);
    }
}

@end
