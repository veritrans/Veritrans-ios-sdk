//
//  SNPFreeTextFreeText.h
//
//  Created by Ratna Kumalasari on 5/25/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SNPFreeTextFreeText : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *inquiry;
@property (nonatomic, strong) NSArray *payment;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
