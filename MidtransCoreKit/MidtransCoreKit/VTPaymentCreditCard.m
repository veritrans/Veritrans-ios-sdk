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
@property (nonatomic, readwrite) VTCreditCard *card;
@property (nonatomic, readwrite) VTUser *user;
@property (nonatomic, readwrite) NSString *bank;
@property (nonatomic, readwrite) NSString *tokenId;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@property (nonatomic, readwrite) NSArray *items;
@property (nonatomic, readwrite) BOOL secure;

@property (nonatomic, strong) VTWebViewController *webTransViewController;
@property (nonatomic, copy) void (^tokenCallback)(id response, NSError *error);
@end

@implementation VTPaymentCreditCard

@synthesize items;
@synthesize user;

+ (instancetype)paymentWithCard:(VTCreditCard *)card
                           bank:(NSString *)bank
                         secure:(BOOL)secure
                           user:(VTUser *)user
                          items:(NSArray *)items {
    VTPaymentCreditCard *payment = [[VTPaymentCreditCard alloc] initWithItems:items user:user];
    payment.card = card;
    payment.bank = bank;
    payment.secure = secure;
    payment.user = user;
    payment.items = items;
    payment.grossAmount = [items amount];
    return payment;
}

//- (void)saveWithCVV:(NSString *)cvv {
//    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] merchantServerURL], @"card"];
//    NSDictionary *parameter = @{@"card_cvv":cvv,
//                                @"":};
//}

#pragma mark - Public

+ (void)getSavedCardWithCalback:(void(^)(id response, NSError *error))callback {
    
}

- (void)payWithCVV:(NSString *)cvv callback:(void(^)(id response, NSError *error))callback {
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

- (void)saveCardAndSavedTokenId:(id)savedToken callback:(void(^)(id response, NSError *error))callback {
    
}

- (void)getTokenWithCVV:(NSString *)cvv callback:(void(^)(id response, NSError *error))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] baseUrl], @"token"];
    NSDictionary *param = @{@"client_key":[[VTConfig sharedInstance] clientKey],
                            @"card_number":self.card.number,
                            @"card_exp_month":self.card.expiryMonth,
                            @"card_exp_year":self.card.expiryYear,
                            @"card_cvv":cvv,
                            @"secure":self.secure?@"true":@"false",
                            @"bank":self.bank,
                            @"gross_amount":self.grossAmount,
                            @"card_type":self.card.type
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

- (NSDictionary *)transactionDetail {
    return @{@"order_id":self.orderId, @"gross_amount":self.grossAmount};
}

- (NSDictionary *)creditCardData {
    return @{@"token_id":self.tokenId,
             @"bank":self.bank,
             @"save_token_id":self.card.saved?@"true":@"false"};
}

- (void)chargeWithCallback:(void(^)(id response, NSError *error))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] merchantServerURL], @"charge"];
    NSDictionary *parameter = @{@"payment_type":@"credit_card",
                                @"credit_card":[self creditCardData],
                                @"transaction_details":[self transactionDetail],
                                @"customer_details":self.user.requestData,
                                @"item_details":self.items.convertItemsToRequestData};
    
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
