//
//  VTFontCollection.m
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTFontSource.h"

@interface VTFontSource()
@property (nonatomic) NSString *fontBoldPath;
@property (nonatomic) NSString *fontRegularPath;
@property (nonatomic) NSString *fontLightPath;
@end

@implementation VTFontSource

- (instancetype)initWithBoldFontPath:(NSString *)fontBoldPath
                     regularFontPath:(NSString *)fontRegularPath
                       lightFontPath:(NSString *)fontLightPath
{
    if (self = [super init]) {
        self.fontBoldPath = fontBoldPath;
        self.fontLightPath = fontLightPath;
        self.fontRegularPath = fontRegularPath;
    }
    return self;
}

@end
