//
//  MIDItemDetails.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutOption.h"
#import "MIDItem.h"

@interface MIDCheckoutItem : NSObject<MIDCheckoutOption>

@property (nonatomic) NSArray <MIDItem *> *items;

- (instancetype)initWithItems:(NSArray <MIDItem *> *)items;

@end
