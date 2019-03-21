//
//  VTInstruction.m
//
//  Created by Nanang  on 8/16/16
//  Copyright (c) 2016 Zahir. All rights reserved.
//

#import "VTInstruction.h"


NSString *const kVTInstructionContent = @"content";
NSString *const kVTInstructionImage = @"image";


@interface VTInstruction ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation VTInstruction

@synthesize content = _content;
@synthesize image = _image;


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
            self.content = [self objectOrNilForKey:kVTInstructionContent fromDictionary:dict];
            self.image = [self objectOrNilForKey:kVTInstructionImage fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.content forKey:kVTInstructionContent];
    [mutableDict setValue:self.image forKey:kVTInstructionImage];

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
