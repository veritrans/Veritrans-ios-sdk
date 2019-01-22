//
//  MIDItemDetails.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCheckoutable.h"
#import "MIDItem.h"

@interface MIDCheckoutItems : NSObject<MIDCheckoutable>

@property (nonatomic) NSArray <MIDItem *> *items;

- (instancetype _Nonnull)initWithItems:(NSArray <MIDItem *> *)items;

@end
