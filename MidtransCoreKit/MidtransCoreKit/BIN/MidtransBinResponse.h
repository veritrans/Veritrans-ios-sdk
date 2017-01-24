//
//  MidtransBinResponse.h
//
//  Created by Zanna Simarmata on 12/22/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransBinResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *bins;
@property (nonatomic, strong) NSString *bank;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
