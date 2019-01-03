//
//  MIDInstallmentInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDInstallmentInfo : NSObject <MIDMappable>

@property (nonatomic) BOOL required;
@property (nonatomic) NSDictionary <NSString *, NSArray <NSNumber *> *> *terms;

@end

NS_ASSUME_NONNULL_END
