//
//  VTPaymentCreditCard.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentCreditCard.h"
#import "VTNetworking.h"
#import "VTConfig.h"
#import "VTWebViewController.h"
#import "VTHelper.h"

@interface VTPaymentCreditCard() <VTWebViewControllerDelegate>
@property (nonatomic, readwrite) NSString *tokenId;
@property (nonatomic, strong) VTWebViewController *webTransViewController;
@property (nonatomic, copy) void (^tokenCallback)(id response, NSError *error);
@end

@implementation VTPaymentCreditCard

#pragma mark - Public

- (void)payWithCard:(VTCreditCard *)card cvv:(NSString *)cvv callback:(void (^)(id, NSError *))callback {
    [self getTokenWithCard:card cvv:cvv callback:^(id response, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        } else {
            [self chargeCreditCard:card withCallback:callback];
        }
    }];
}

#pragma mark - Private

- (void)getTokenWithCard:(VTCreditCard *)card cvv:(NSString *)cvv callback:(void(^)(id response, NSError *error))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] baseUrl], @"token"];
    NSDictionary *param = @{@"client_key":[[VTConfig sharedInstance] clientKey],
                            @"card_number":card.number,
                            @"card_exp_month":card.expiryMonth,
                            @"card_exp_year":card.expiryYear,
                            @"card_cvv":cvv,
                            @"secure":self.secure?@"true":@"false",
                            @"bank":self.bank,
                            @"gross_amount":self.grossAmount,
                            @"card_type":card.type
                            };
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:param callback:^(id response, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        } else {
            //set token id
            __weak VTPaymentCreditCard *wself = self;
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

- (NSDictionary *)requestDataCreditCard:(VTCreditCard *)card {
    return @{@"token_id":self.tokenId,
             @"bank":self.bank,
             @"save_token_id":card.saved?@"true":@"false"};
}

- (void)chargeCreditCard:(VTCreditCard *)card withCallback:(void(^)(id response, NSError *error))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] merchantServerURL], @"charge"];
    NSDictionary *parameter = @{@"payment_type":@"credit_card",
                                @"credit_card":[self requestDataCreditCard:card],
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
