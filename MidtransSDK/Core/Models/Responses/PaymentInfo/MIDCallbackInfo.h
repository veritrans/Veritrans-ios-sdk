//
//  MIDCallbackInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface MIDCallbackInfo : NSObject <MIDMappable>

@property (nonatomic) NSString *error;
@property (nonatomic) NSString *finish;

@end
