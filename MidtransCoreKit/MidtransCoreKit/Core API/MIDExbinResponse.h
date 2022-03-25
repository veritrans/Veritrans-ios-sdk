//
//  MIDExbinResponse.h
//  MidtransCoreKit
//
//  Created by Muhammad Fauzi Masykur on 20/03/22.
//  Copyright © 2022 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDExbinData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDExbinResponse : NSObject <NSCoding, NSCopying>
@property (nonatomic, strong) MIDExbinData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END
