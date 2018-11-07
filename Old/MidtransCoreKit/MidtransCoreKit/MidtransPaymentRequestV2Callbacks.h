//
//  MidtransPaymentRequestV2Callbacks.h
//
//  Created by Ratna Kumalasari on 10/25/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPaymentRequestV2Callbacks : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *finish;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
