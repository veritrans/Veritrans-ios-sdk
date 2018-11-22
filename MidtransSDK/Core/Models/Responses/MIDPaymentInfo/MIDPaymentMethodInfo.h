//
//  MIDPaymentMethodInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface MIDPaymentMethodInfo : NSObject <MIDMappable>

@property (nonatomic) NSString *status;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *category;

@end
