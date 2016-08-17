//
//  VTInstruction.h
//
//  Created by Nanang  on 8/16/16
//  Copyright (c) 2016 Zahir. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VTInstruction : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *image;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
