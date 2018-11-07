//
//  AddOnConstructor.h
//
//  Created by Zanna Simarmata on 1/24/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AddOnConstructor : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *addOnTitle;
@property (nonatomic, strong) NSString *addOnDescriptions;
@property (nonatomic, strong) NSString *addOnName;
@property (nonatomic, strong) NSString *addOnAddtional;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
