//
//  MidtransPaymentRequestV2Preference.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPaymentRequestV2Preference : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *finishUrl;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSString *colorSchemeUrl;
@property (nonatomic, strong) NSString *pendingUrl;
@property (nonatomic, strong) NSString *colorScheme;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *errorUrl;
@property (nonatomic, strong) NSString *otherVAProcessor;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
