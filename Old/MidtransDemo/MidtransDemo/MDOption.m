//
//  MDOption.m
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 4/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MDOption.h"

@implementation MDOption

+ (MDOption *)optionGeneralWithName:(NSString *)name value:(id)value {
    MDOption *opt = [MDOption new];
    opt.name = name;
    opt.type = MDOptionTypeGeneral;
    opt.value = value;
    return opt;
}
+ (MDOption *)optionColorWithName:(NSString *)name value:(UIColor *)value {
    MDOption *opt = [MDOption new];
    opt.name = name;
    opt.type = MDOptionTypeColor;
    opt.value = value;
    return opt;
}
+ (MDOption *)optionComposer:(MDComposerType)composerType name:(NSString *)name value:(id)value {
    MDOption *opt = [MDOption new];
    opt.type = MDOptionTypeComposer;
    opt.composerType = composerType;
    opt.name = name;
    opt.value = value;
    return opt;
}
+ (MDOption *)optionCheckListWithName:(NSString *)name checkedList:(NSArray *)checkedList {
    MDOption *opt = [MDOption new];
    opt.type = MDOptionTypeComposer;
    opt.composerType = MDComposerTypeCheck;
    opt.name = name;
    opt.value = checkedList;
    return opt;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.type = [decoder decodeIntegerForKey:@"type"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.value = [decoder decodeObjectForKey:@"value"];
        self.subName = [decoder decodeObjectForKey:@"subname"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.value forKey:@"value"];
    [encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeObject:self.subName forKey:@"subname"];
}
@end
