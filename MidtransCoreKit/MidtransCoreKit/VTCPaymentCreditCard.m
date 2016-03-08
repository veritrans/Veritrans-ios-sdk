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
#import "VT3DSController.h"
#import "VTHelper.h"

@interface VTCPaymentCreditCard() <VT3DSControllerDelegate>
@property (nonatomic, readwrite) VTCreditCard *creditCard;
@property (nonatomic, readwrite) NSString *tokenId;
@property (nonatomic, strong) VT3DSController *secureController;
@property (nonatomic, copy) void (^tokenCallback)(id response, NSError *error);
@end

@implementation VTCPaymentCreditCard

- (void)chargeWithCard:(VTCreditCard *)card
                   cvv:(NSString *)cvv
              saveCard:(BOOL)saveCard
              callback:(void (^)(id response, NSError *error))callback
{
    _creditCard = card;
    
    [self getTokenWithCVV:cvv callback:^(id response, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        } else {
            NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"charge"];
            NSDictionary *parameter = @{@"payment_type":@"credit_card",
                                        @"credit_card":[self creditCardRequestData],
                                        @"transaction_details":[self transactionDetail],
                                        @"customer_details":[self.user customerDetails],
                                        @"item_details":[self.items itemsRequestData]};
            
            [[VTNetworking sharedInstance] postToURL:URL parameters:parameter callback:^(id response, NSError *error) {
                if (response) {
                    NSDictionary *card = @{@"holder":_creditCard.holder,
                                           @"token_id":response[@"saved_token_id"],
                                           @"expiry_token_id":response[@"saved_token_id_expired_at"],
                                           @"masked_card_number":response[@"masked_card"]};
                    [[NSUserDefaults standardUserDefaults] saveNewCard:card];
                }
                
                if (callback) {
                    callback(response, error);
                }
            }];
        }
    }];
}

- (void)chargeWithSavedCard:(id)savedCard cvv:(NSString *)cvv callback:(void (^)(id response, NSError *error))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantServerURL], @"charge"];
    
    NSDictionary *ccData;
    
    if ([CONFIG creditCardFeature] == VTCreditCardFeatureOneClick) {
        ccData = @{@"token_id":savedCard[@"token_id"]};
    } else {
        ccData = @{@"card_cvv":cvv,
                   @"token_id":savedCard[@"token_id"],
                   @"two_click":@"true",
                   @"secure":@"true",
                   @"gross_amount":[self.items itemsPriceAmount]};
    }
    
    NSDictionary *parameter = @{@"payment_type":@"credit_card",
                                @"credit_card":ccData,
                                @"transaction_details":[self transactionDetail],
                                @"customer_details":[self.user customerDetails],
                                @"item_details":[self.items itemsRequestData]};
    
    [[VTNetworking sharedInstance] postToURL:URL parameters:parameter callback:^(id response, NSError *error) {
        if (response) {
            id savedTokenId = response[@"saved_token_id"];
            if (savedTokenId) {
                NSDictionary *card = @{@"holder":_creditCard.holder,
                                       @"token_id":response[@"saved_token_id"],
                                       @"expiry_token_id":response[@"saved_token_id_expired_at"],
                                       @"masked_card_number":response[@"masked_card"]};
                [[NSUserDefaults standardUserDefaults] saveNewCard:card];
            }
        }
        
        if (callback) {
            callback(response, error);
        }
    }];
}

#pragma mark - Private

- (void)getTokenWithCVV:(NSString *)cvv callback:(void(^)(id response, NSError *error))callback {
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG baseUrl], @"token"];
    
    NSDictionary *param = @{@"client_key":[CONFIG clientKey],
                            @"secure":[CONFIG secureCreditCardPayment] ? @"true":@"false",
                            @"card_number":_creditCard.number,
                            @"card_exp_month":_creditCard.expiryMonth,
                            @"card_exp_year":_creditCard.expiryYear,
                            @"card_type":[VTCreditCard typeStringWithNumber:_creditCard.number],
                            @"card_cvv":cvv,
                            @"gross_amount":[self.items itemsPriceAmount]
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
            if (!self.secureController) {
                self.secureController = [[VT3DSController alloc] init];
            }
            self.secureController.webDelegate = self;
            self.secureController.webUrl = [NSURL URLWithString:response[@"redirect_url"]];
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:self.secureController];            
            [[UIApplication rootViewController] presentViewController:navigation animated:YES completion:nil];
        }
    }];
}

- (NSDictionary *)creditCardRequestData {
//    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:@{@"token_id":self.tokenId}];
//    switch ([CONFIG creditCardFeature]) {
//        case VTCreditCardFeatureTwoClick:
//        case VTCreditCardFeatureOneClick:
//            [data setObject:@"true" forKey:@"save_token_id"];
//            break;
//        default:
//            [data setObject:@"false" forKey:@"save_token_id"];
//            break;
//    }
//    return data;
    
    return @{@"token_id":self.tokenId,
             @"save_token_id":@"true"};
}

#pragma mark - VT3DSControllerDelegate

- (void)viewController_didFinishTransaction:(VT3DSController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.tokenCallback) {
        self.tokenCallback(nil, nil);
    }
}

@end
