//
//  MIDCheckoutIdentifier.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 02/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCheckoutIdentifier : NSObject <MIDCheckoutable>

- (instancetype)initWithUserIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
