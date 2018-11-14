//
//  MIDModelHelper.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDMappable.h"

@interface NSDictionary (extract)

- (id)objectOrNilForKey:(id)key;

@end

@interface NSArray (parse)

- (NSArray *)dictionaryValues;

@end
