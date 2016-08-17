//
//  VTGroupedInstruction.h
//
//  Created by Nanang  on 8/16/16
//  Copyright (c) 2016 Zahir. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VTInstruction;

@interface VTGroupedInstruction : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<VTInstruction*>*instructions;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
