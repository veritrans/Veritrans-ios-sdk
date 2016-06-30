//
//  VTFontCollection.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 6/30/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTFontSource : NSObject

@property (nonatomic, readonly) NSString *fontBoldPath;
@property (nonatomic, readonly) NSString *fontRegularPath;
@property (nonatomic, readonly) NSString *fontLightPath;

- (instancetype)initWithBoldFontPath:(NSString *)fontBoldPath
                     regularFontPath:(NSString *)fontRegularPath
                       lightFontPath:(NSString *)fontLightPath;
@end
