//
//  MIDToken.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDToken : NSObject <MIDMappable>
@property (nonatomic) NSString *token;
@property (nonatomic) NSString *redirectURL;
@end

NS_ASSUME_NONNULL_END
