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

@interface MDOption : NSObject<NSCoding>
+ (MDOption *)optionGeneralWithName:(NSString *)name value:(id)value;
+ (MDOption *)optionColorWithName:(NSString *)name value:(UIColor *)value;
+ (MDOption *)optionComposerWithName:(NSString *)name value:(id)value;

@property (nonatomic, assign) MDOptionType type;
@property (nonatomic) NSString *name;
@property (nonatomic) id value;
@end
