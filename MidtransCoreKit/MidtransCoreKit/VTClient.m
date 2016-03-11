//
//  VTClient.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/8/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTClient.h"
#import "VTConfig.h"
#import "VTNetworking.h"
#import "VT3DSController.h"
#import "VTHelper.h"

@interface VTClient() <VT3DSControllerDelegate>
@property (nonatomic, readwrite) NSString *tokenId;
@property (nonatomic, strong) VT3DSController *secureController;
@property (nonatomic, copy) void (^generateTokenCompletion)(id response, NSError *error);
@end

@implementation VTClient

+ (id)sharedClient {
    // Idea stolen from http://www.galloway.me.uk/tutorials/singleton-classes/
    static VTClient *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)generateToken:(VTTokenRequest *)tokenRequest
           completion:(void (^)(NSString *token, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG baseUrl], @"token"];
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:[tokenRequest dictionaryValue] callback:^(id response, NSError *error) {
        if (error) {
            if (completion) completion(nil, error);
        } else {
            __weak VTClient *wself = self;
            
            //set token id
            wself.tokenId = response[@"token_id"];
            
            //set callback
            self.generateTokenCompletion = completion;
            
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

- (void)registerCreditCard:(VTCreditCard *)creditCard
                completion:(void (^)(VTRegisteredCreditCard *registeredCard, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG baseUrl], @"card/register"];
    NSDictionary *param = @{@"card_number":creditCard.number,
                            @"card_exp_month":creditCard.expiryMonth,
                            @"card_exp_year":creditCard.expiryYear};
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:param callback:^(id response, NSError *error) {
        [VTHelper handleResponse:response completion:^(id response, NSError *error) {
            if (response) {
                VTRegisteredCreditCard *registeredCard = [VTRegisteredCreditCard registeredCardFromData:response];
                if (completion) completion(registeredCard, nil);
            } else {
                if (completion) completion(nil, error);
            }
        }];
    }];
}

#pragma mark - VT3DSControllerDelegate

- (void)viewController_didFinishTransaction:(VT3DSController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.generateTokenCompletion) {
        self.generateTokenCompletion(self.tokenId, nil);
    }
}


@end
