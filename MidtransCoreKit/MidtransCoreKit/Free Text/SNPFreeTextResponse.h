//
//  SNPFreeTextResponse.h
//
//  Created by Ratna Kumalasari on 5/25/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNPFreeTextFreeText;

@interface SNPFreeTextResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) SNPFreeTextFreeText *freeText;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
