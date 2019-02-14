//
//  MIDPaymentMethodInfo.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"
#import "MIDModelEnums.h"

@interface MIDPaymentMethodInfo : NSObject <MIDMappable>

@property (nonatomic) BOOL isActive;
@property (nonatomic) MIDPaymentMethod type;
@property (nonatomic) MIDPaymentCategory category;

@end
