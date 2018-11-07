//
//  MDPayment.h
//
//  Created by Nanang  on 5/8/17
//  Copyright (c) 2017 Zahir. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MDPayment : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
