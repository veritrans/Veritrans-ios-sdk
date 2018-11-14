//
//  MIDPreferenceInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface MIDPreferenceInfo : NSObject <MIDMappable>

@property (nonatomic) NSString *colorScheme;
@property (nonatomic) NSString *colorSchemeURL;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *errorURL;
@property (nonatomic) NSString *finishURL;
@property (nonatomic) NSString *trackingCodeGA;
@property (nonatomic) NSString *locale;
@property (nonatomic) NSString *otherVAProcessor;
@property (nonatomic) NSString *pendingURL;
@property (nonatomic) NSString *vtwebVersion;

@end
