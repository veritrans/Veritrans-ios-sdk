//
//  MIDExbinData.h
//  MidtransCoreKit
//
//  Created by Muhammad Fauzi Masykur on 20/03/22.
//  Copyright © 2022 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIDExbinData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *binType;
@property (nonatomic, strong) NSString *binClass;
@property (nonatomic, strong) NSString *bin;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *bank;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END
