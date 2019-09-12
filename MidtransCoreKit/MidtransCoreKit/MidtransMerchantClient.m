//
//  VTMerchantClient.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransMerchantClient.h"
#import "MidtransConfig.h"
#import "SNPPointDataModels.h"
#import "MidtransNetworking.h"
#import "MidtransConstant.h"
#import "MidtransPrivateConfig.h"
#import "MidtransHelper.h"
#import "MidtransPaymentWebController.h"
#import "MidtransTransactionTokenResponse.h"
#import "MidtransCoreKit.h"

NSString *const SAVE_MASKEDCARD_URL = @"%@/users/%@/tokens";
NSString *const FETCH_MASKEDCARD_URL = @"%@/users/%@/tokens";


@interface NSArray (MaskedCard)

- (NSArray *)requestBodyValues;

@end

@implementation NSArray (MaskedCard)

- (NSArray *)requestBodyValues {
    NSMutableArray *parameter = [[NSMutableArray alloc] init];
    for (MidtransMaskedCreditCard *maskedCard in self) {
        [parameter addObject:maskedCard.dictionaryValue];
    }
    return parameter;
}

@end

@implementation MidtransMerchantClient

+ (MidtransMerchantClient *)shared {
    static MidtransMerchantClient *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void)performCheckStatusTransactionWithToken:(NSString *_Nonnull)token completion:(void (^_Nonnull)(MidtransTransactionResult * _Nullable, NSError * _Nullable))completion {
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers addEntriesFromDictionary:[CONFIG merchantClientData]];
    MidtransTransaction *transaction = [MidtransTransaction new];
    [[MidtransNetworking shared] getFromURL:[transaction checkStatusTransaction:token] header:headers parameters:nil callback:^(id response, NSError *error) {
        
        NSString *paymentType = transaction.paymentType;
        
        if (response) {
            MidtransTransactionResult *chargeResult = [[MidtransTransactionResult alloc] initWithTransactionResponse:response];
            if ([paymentType isEqualToString:MIDTRANS_PAYMENT_GOPAY]) {
                if (completion) {
                    completion(chargeResult, error);
                }
            }
            else {
                if (completion) {
                    completion(chargeResult, error);
                }
            }
        }
        else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
    
}
- (void)performCheckStatusRBA:(MidtransTransaction *)transaction
                completion:(void(^)(MidtransTransactionResult *result, NSError *error))completion {
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers addEntriesFromDictionary:[CONFIG merchantClientData]];
    [[MidtransNetworking shared] getFromURL:[transaction checkStatusRBA] header:headers parameters:nil callback:^(id response, NSError *error) {
        
        NSString *paymentType = transaction.paymentType;
        
        if (response) {
            MidtransTransactionResult *chargeResult = [[MidtransTransactionResult alloc] initWithTransactionResponse:response];
            if ([paymentType isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
                if (completion) {
                    completion(chargeResult, error);
                }
            }
            else {
                if (completion) {
                    completion(chargeResult, error);
                }
            }
        }
        else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)performTransaction:(MidtransTransaction *)transaction
                completion:(void(^)(MidtransTransactionResult *result, NSError *error))completion {
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers addEntriesFromDictionary:[CONFIG merchantClientData]];
    [[MidtransNetworking shared] postToURL:[transaction chargeURL] header:headers parameters:[transaction dictionaryValue] callback:^(id response, NSError *error) {
        
        NSString *paymentType = transaction.paymentType;
        
        if (response) {
            MidtransTransactionResult *chargeResult = [[MidtransTransactionResult alloc] initWithTransactionResponse:response];
            if ([paymentType isEqualToString:MIDTRANS_PAYMENT_CREDIT_CARD]) {
                if (completion) {
                    completion(chargeResult, error);
                }
            }
            else {
                if (completion) {
                    completion(chargeResult, error);
                }
            }
        }
        else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)deleteMaskedCreditCard:(MidtransMaskedCreditCard *)maskedCard
                         token:(MidtransTransactionTokenResponse *)token
                    completion:(void(^)(BOOL success))completion {
    NSString *stringURL = [NSString stringWithFormat:@"%@/transactions/%@/saved_tokens/%@",PRIVATECONFIG.snapURL, token.tokenId, maskedCard.maskedNumber];
    NSDictionary *parameter = @{@"token":token.tokenId,
                                @"masked_card":maskedCard.maskedNumber};
    [[MidtransNetworking shared] deleteFromURL:stringURL header:nil parameters:parameter callback:^(id response, NSError *error) {
        BOOL success = YES;
        if (error) {
            success = NO;
        }
        if (response[@"error_message"]) {
            success = NO;
        }
        if (completion) completion(success);
    }];
}

- (void)saveMaskedCards:(NSArray <MidtransPaymentCreditCard*>*)maskedCards
               customer:(MidtransCustomerDetails *)customer
             completion:(void(^)(id result, NSError *error))completion {
    NSString *URL = [NSString stringWithFormat:SAVE_MASKEDCARD_URL, [CONFIG merchantURL], customer.customerIdentifier];;
    NSArray *parameters = maskedCards.requestBodyValues;
    [[MidtransNetworking shared] postToURL:URL header:[CONFIG merchantClientData] parameters:parameters callback:completion];
}

- (void)fetchMaskedCardsCustomer:(MidtransCustomerDetails *)customer completion:(void(^)(NSArray *maskedCards, NSError *error))completion {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:FETCH_MASKEDCARD_URL, [CONFIG merchantURL], customer.customerIdentifier]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         if (data) {
             NSMutableArray *result = [[NSMutableArray alloc] init];
             NSError *error;
             id requestResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
             
             if (!error) {
                 for (NSDictionary *dictionary in requestResponse) {
                     MidtransMaskedCreditCard *card = [[MidtransMaskedCreditCard alloc] initWithDictionary:dictionary];
      
                     [result addObject:card];
                 }
             }
             if (completion) completion(result, nil);
         }
         else {
             if (completion) completion(nil, error);
         }
     }];
}

#pragma mark - Helper

- (BOOL)isWebPaymentType:(NSString *)paymentType {
    return [paymentType isEqualToString:MIDTRANS_PAYMENT_CIMB_CLICKS] ||
    [paymentType isEqualToString:MIDTRANS_PAYMENT_BCA_KLIKPAY] ||
    [paymentType isEqualToString:MIDTRANS_PAYMENT_MANDIRI_ECASH] ||
    [paymentType isEqualToString:MIDTRANS_PAYMENT_BRI_EPAY];
}
- (void)requestCustomerPointWithToken:(NSString * _Nonnull )token
                   andCreditCardToken:(NSString *_Nonnull)creditCardToken
                           completion:(void (^_Nullable)(SNPPointResponse *_Nullable response, NSError *_Nullable error))completion {
    NSString *stringURL = [NSString stringWithFormat:@"%@/transactions/%@/point_inquiry/%@",PRIVATECONFIG.snapURL, token, creditCardToken];
    @try {
        [[MidtransNetworking shared] getFromURL:stringURL parameters:nil callback:^(id response, NSError *error) {
            if (!error) {
                SNPPointResponse *pointResponse = [[SNPPointResponse alloc] initWithDictionary:(NSDictionary *)response];
                if (completion) {
                    completion(pointResponse,NULL);
                }
            }
            else {
                if (completion) {
                    completion(NULL,error);
                }
            }
        }];
    }
    @catch (NSException * e) {
        [[SNPErrorLogManager shared] trackException:e className:[[self class] description]];
    }
   
    
}
- (void)requestTransacationWithCurrentToken:(NSString *_Nonnull)token
                                 completion:(void (^_Nullable)(MidtransTransactionTokenResponse *_Nullable regenerateToken, NSError *_Nullable error))completion {
    
    NSString *URL = [NSString stringWithFormat:ENDPOINT_TRANSACTION_DETAIL, [PRIVATECONFIG snapURL], token];
    [[MidtransNetworking shared] getFromURL:URL parameters:nil callback:^(id response, NSError *error) {
        if (!error) {
            MidtransPaymentRequestV2Response *paymentRequestV2 = [[MidtransPaymentRequestV2Response alloc] initWithDictionary:(NSDictionary *)response];
            
            if (completion) {
                MidtransTransactionTokenResponse *token2;
                
                MidtransAddress *billAddressConstruct = [MidtransAddress addressWithFirstName:paymentRequestV2.customerDetails.billingAddress.firstName
                                                                                      lastName:paymentRequestV2.customerDetails.billingAddress.firstName
                                                                                         phone:paymentRequestV2.customerDetails.billingAddress.phone
                                                                                       address:paymentRequestV2.customerDetails.billingAddress.firstName
                                                                                          city:paymentRequestV2.customerDetails.billingAddress.city
                                                                                    postalCode:paymentRequestV2.customerDetails.billingAddress.postalCode
                                                                                   countryCode:paymentRequestV2.customerDetails.billingAddress.countryCode];
                
                                                         
                NSNumber *amount =  [NSNumber numberWithDouble:[paymentRequestV2.transactionDetails.grossAmount doubleValue]];
                MidtransTransactionDetails *reConstructTransactionDetail = [[MidtransTransactionDetails alloc] initWithOrderID:paymentRequestV2.transactionDetails.orderId
                                                                                                                andGrossAmount:amount];

                
                
                MidtransCustomerDetails *customerDetailsMock = [[MidtransCustomerDetails alloc] initWithFirstName:paymentRequestV2.customerDetails.firstName
                                                                                                         lastName:paymentRequestV2.customerDetails.firstName
                                                                                                            email:paymentRequestV2.customerDetails.email
                                                                                                            phone:paymentRequestV2.customerDetails.phone
                                                                                                  shippingAddress:billAddressConstruct
                                                                                                   billingAddress:billAddressConstruct];
                NSMutableArray *itemDetails = [NSMutableArray new];
                
                for (MidtransPaymentRequestV2ItemDetails *detail in paymentRequestV2.itemDetails) {
                    MidtransItemDetail *regenerate = [[MidtransItemDetail alloc]initWithItemID:detail.itemDetailsIdentifier name:detail.name price:[NSNumber numberWithDouble:detail.price] quantity:[NSNumber numberWithDouble:detail.quantity]];
                    [itemDetails addObject:regenerate];
                }
                token2 = [MidtransTransactionTokenResponse modelObjectWithDictionary:@{@"token":token}
                                                                  transactionDetails:reConstructTransactionDetail
                                                                     customerDetails:customerDetailsMock
                                                                         itemDetails:itemDetails];
                
                completion(token2,NULL);
            }
            
        }
        else {
            if (completion) {
                completion(NULL,error);
            }
        }
    }];
}
- (void)requestTransactionTokenWithTransactionDetails:(nonnull MidtransTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<MidtransItemDetail*> *)itemDetails
                                      customerDetails:(nullable MidtransCustomerDetails *)customerDetails
                                          customField:(nullable NSArray *)customField
                                            binFilter:(nullable NSArray *)binFilter
                                   blacklistBinFilter:(nullable NSArray *)blackListBin
                                transactionExpireTime:(MidtransTransactionExpire *)expireTime
                                           completion:(void (^_Nullable)(MidtransTransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion {
    NSMutableDictionary *dictionaryParameters = [NSMutableDictionary new];
    [dictionaryParameters setValue:[transactionDetails dictionaryValue] forKey:MIDTRANS_CORE_SNAP_PARAMETER_TRANSACTION_DETAILS];
    
    [dictionaryParameters setValue:[customerDetails dictionaryValue] forKey:MIDTRANS_CORE_SNAP_PARAMETER_CUSTOMER_DETAILS];
    [dictionaryParameters setValue:[itemDetails itemDetailsDictionaryValue] forKey:MIDTRANS_CORE_SNAP_PARAMETER_ITEM_DETAILS];
    [dictionaryParameters setValue:customerDetails.customerIdentifier forKey:@"user_id"];
    
    if ([customField count] || [customField isEqual:[NSNull null]]) {
        for (NSDictionary *dictionary in customField) {
            NSArray *key_dictionary=[dictionary allKeys];
            for (NSString *string_key in key_dictionary) {
                [dictionaryParameters setValue:[dictionary objectForKey:string_key] forKey:string_key];
            }
        }
    }
    if ([[expireTime dictionaryRepresentation] count] || [expireTime isEqual:[NSNull null]]) {
        [dictionaryParameters setValue:[expireTime dictionaryRepresentation] forKey:MIDTRANS_CORE_SNAP_PARAMETER_EXPIRE_TIME];
    }
    
    NSMutableDictionary *creditCardParameter = [NSMutableDictionary new];
    [creditCardParameter setValue:@(CC_CONFIG.saveCardEnabled) forKey:@"save_card"];
    
    if (CC_CONFIG.predefinedInstallment) {
        creditCardParameter[@"installment"] = CC_CONFIG.predefinedInstallment.dictionaryRepresentation;
    }
    if (binFilter.count > 0) {
        creditCardParameter[@"whitelist_bins"] = binFilter;
    }
    if (blackListBin.count > 0) {
        creditCardParameter[@"blacklist_bins"] = blackListBin;
    }
    if (CC_CONFIG.acquiringBankString) {
        creditCardParameter[@"bank"] = CC_CONFIG.acquiringBankString;
    }
    if (CC_CONFIG.authenticationTypeString!=nil || [CC_CONFIG.authenticationTypeString length]>0) {
        if (CC_CONFIG.authenticationType == MTAuthenticationTypeNone) {
            [creditCardParameter setValue:@"false" forKey:@"secure"];
            creditCardParameter[@"authentication"] = CC_CONFIG.authenticationTypeString;
        }
        else  if(CC_CONFIG.authenticationType == MTAuthenticationType3DS) {
            [creditCardParameter setValue:@"true" forKey:@"secure"];
            creditCardParameter[@"authentication"] = CC_CONFIG.authenticationTypeString;
        }
        else  if(CC_CONFIG.authenticationType == MTAuthenticationTypeRBA) {
            [creditCardParameter setValue:@"false" forKey:@"secure"];
            creditCardParameter[@"authentication"] = CC_CONFIG.authenticationTypeString;
        }
    }
    if (CC_CONFIG.preauthEnabled) {
        creditCardParameter[@"type"] = @"authorize";
    }
    if ([CONFIG.customFreeText count]) {
         dictionaryParameters[@"free_text"] = CONFIG.customFreeText;
    }
    [dictionaryParameters setValue:creditCardParameter forKey:@"credit_card"];
    
    if ([CONFIG customPermataVANumber].length > 0) {
        dictionaryParameters[@"permata_va"] = @{@"va_number":CONFIG.customPermataVANumber};
    }
    
    if ([CONFIG customBCAVANumber].length > 0) {
        dictionaryParameters[@"bca_va"] = @{@"va_number":CONFIG.customBCAVANumber};
    }
    if (CONFIG.customPermataVARecipientName) {
        dictionaryParameters[@"bca_va"] = @{@"sub_company_code":CONFIG.customBCASubcompanyCode};
    }
    if ([CONFIG customBCASubcompanyCode].length>0) {
        dictionaryParameters[@"permata_va"] = @{@"recipient_name":[CONFIG.customPermataVARecipientName uppercaseString]};
    }
    if ( [CONFIG customBCASubcompanyCode].length>0 && [CONFIG customBCAVANumber].length > 0) {
         dictionaryParameters[@"bca_va"] = @{@"sub_company_code":CONFIG.customBCASubcompanyCode,
                                             @"va_number":CONFIG.customBCAVANumber
                                             };
    }
    if ([CONFIG customBNIVANumber].length > 0) {
        dictionaryParameters[@"bni_va"] = @{@"va_number":CONFIG.customBNIVANumber};
    }
    
    if (CONFIG.customPaymentChannels.count > 0) {
        dictionaryParameters[@"enabled_payments"] = CONFIG.customPaymentChannels;
    }
    
    if ([CONFIG callbackSchemeURL].length > 0) {
        NSDictionary *gopay = @{@"enable_callback": @YES,
                                @"callback_url": [CONFIG callbackSchemeURL]};
        dictionaryParameters[@"gopay"] = gopay;
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [CONFIG merchantURL], MIDTRANS_CORE_SNAP_MERCHANT_SERVER_CHARGE];
    
    if (CC_CONFIG.promoEnabled) {
        NSMutableDictionary *promoParam = [NSMutableDictionary new];
        promoParam[@"enabled"] = @"YES";
        if (CC_CONFIG.allowedPromoCodes) {
            promoParam[@"allowed_promo_codes"] = CC_CONFIG.allowedPromoCodes;
        }
        dictionaryParameters[@"promo"] = promoParam;
    }
    [[MidtransNetworking shared] postToURL:URL
                                    header:nil
                                parameters:dictionaryParameters
                                  callback:^(id response, NSError *error)
     {
         MidtransTransactionTokenResponse *token;
         if (response) {
             id errorResponse = response[@"error_messages"];
             if (errorResponse) {
                 NSString *errorMessage;
                 if ([errorResponse isKindOfClass:[NSArray class]]) {
                     errorMessage = [errorResponse firstObject];
                 }
                 else if ([errorResponse isKindOfClass:[NSString class]]) {
                     errorMessage = errorResponse;
                 }
                 else {
                     errorMessage = @"Checkout error";
                 }
                 error = [NSError errorWithDomain:MIDTRANS_ERROR_DOMAIN
                                             code:0
                                         userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
             }
             else {
                 token = [MidtransTransactionTokenResponse modelObjectWithDictionary:(NSDictionary *)response
                                                                  transactionDetails:transactionDetails
                                                                     customerDetails:customerDetails
                                                                         itemDetails:itemDetails];
             }
         }
         
         if (completion) {
             completion(token, error);
         }
     }];
    
    
}
- (void)requestTransactionTokenWithTransactionDetails:(nonnull MidtransTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<MidtransItemDetail*> *)itemDetails
                                      customerDetails:(nullable MidtransCustomerDetails *)customerDetails
                                           completion:(void (^_Nullable)(MidtransTransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion {
   [self requestTransactionTokenWithTransactionDetails:transactionDetails
                                           itemDetails:itemDetails
                                       customerDetails:customerDetails
                                           customField:nil
                                             binFilter:nil
                                    blacklistBinFilter:nil
                                 transactionExpireTime:nil
                                            completion:completion];
}

- (void)requestPaymentlistWithToken:(NSString * _Nonnull )token
                         completion:(void (^_Nullable)(MidtransPaymentRequestV2Response *_Nullable response, NSError *_Nullable error))completion {
    NSString *URL = [NSString stringWithFormat:ENDPOINT_TRANSACTION_DETAIL, [PRIVATECONFIG snapURL], token];
    [[MidtransNetworking shared] getFromURL:URL parameters:nil callback:^(id response, NSError *error) {
        if (!error) {
            MidtransPaymentRequestV2Response *paymentRequestV2 = [[MidtransPaymentRequestV2Response alloc] initWithDictionary:(NSDictionary *)response];
            
            if (completion) {
                if ([[paymentRequestV2.merchant.preference dictionaryRepresentation] count]) {
                    [MidtransImageManager getImageFromURLwithUrl:paymentRequestV2.merchant.preference.logoUrl];
                    [[NSUserDefaults standardUserDefaults] setValue:paymentRequestV2.merchant.preference.displayName forKey:MIDTRANS_CORE_MERCHANT_NAME];
                    [[NSUserDefaults standardUserDefaults] setValue:paymentRequestV2.merchant.merchantId forKey:MIDTRANS_TRACKING_MERCHANT_ID];
                    NSArray* strings = [paymentRequestV2.enabledPayments valueForKeyPath:@"@distinctUnionOfObjects.type"];
                    [[NSUserDefaults standardUserDefaults] setValue:strings forKey:MIDTRANS_TRACKING_ENABLED_PAYMENTS];
                    [[NSUserDefaults standardUserDefaults] setValue:token forKey:MIDTRANS_CORE_SAVED_ID_TOKEN];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                completion(paymentRequestV2,NULL);
            }
        }
        else {
            if (completion) {
                completion(NULL,error);
            }
        }
    }];
}

@end
