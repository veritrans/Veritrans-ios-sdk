//
//  MDOption.h
//  MidtransDemo
//
//  Created by Nanang Rafsanjani on 4/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MDOptionType) {
    MDOptionTypeGeneral,
    MDOptionTypeColor,
    MDOptionTypeComposer
};

typedef NS_ENUM(NSUInteger, MDComposerType) {
    MDComposerTypeText,
    MDComposerTypeCheck,
    MDComposerTypeRadio
};

@interface MDOption : NSObject<NSCoding>
+ (MDOption *)optionGeneralWithName:(NSString *)name value:(id)value;
+ (MDOption *)optionColorWithName:(NSString *)name value:(UIColor *)value;
+ (MDOption *)optionComposer:(MDComposerType)composerType name:(NSString *)name value:(id)value;

@property (nonatomic, assign) MDOptionType type;
@property (nonatomic, assign) MDComposerType composerType;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *subName;
@property (nonatomic) id value;
@end
