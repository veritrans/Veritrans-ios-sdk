//
//  VTGroupedInstruction.m
//
//  Created by Nanang  on 8/16/16
//  Copyright (c) 2016 Zahir. All rights reserved.
//

#import "VTGroupedInstruction.h"
#import "VTInstruction.h"


NSString *const kVTGroupedInstructionName = @"name";
NSString *const kVTGroupedInstructionGuides = @"guides";


@interface VTGroupedInstruction ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation VTGroupedInstruction

@synthesize name = _name;
@synthesize instructions = _instructions;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.name = [self objectOrNilForKey:kVTGroupedInstructionName fromDictionary:dict];
        
        NSArray *guides = [dict objectForKey:kVTGroupedInstructionGuides];
        NSMutableArray *instructionsM = [NSMutableArray new];
        for (NSDictionary *instructionData in guides) {
            VTInstruction *instruction = [VTInstruction modelObjectWithDictionary:instructionData];
            [instructionsM addObject:instruction];
        }
        self.instructions = instructionsM;
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kVTGroupedInstructionName];
    [mutableDict setValue:self.instructions forKey:kVTGroupedInstructionGuides];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
