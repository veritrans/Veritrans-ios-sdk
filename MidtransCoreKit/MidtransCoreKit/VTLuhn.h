//
//  VTLuhn.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/4/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VTLuhn : NSObject

+ (BOOL) validateString:(NSString *) string;

@end

@interface NSString (VTLuhn)

- (NSString *) formattedStringForProcessing;

@end