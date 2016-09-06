//
//  PaymentRequestMerchantData.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPaymentRequestMerchantData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *clientKey;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSString *unFinishUrl;
@property (nonatomic, strong) NSString *errorUrl;
@property (nonatomic, strong) NSString *finishUrl;
@property (nonatomic, strong) NSString *colorScheme;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
- (NSString *)merchantName;
@end
