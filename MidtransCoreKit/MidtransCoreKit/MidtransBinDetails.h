//
//  MidtransBinDetails.h
//  MidtransCoreKit
//
//  Created by Muhammad Fauzi Masykur on 06/04/22.
//  Copyright © 2022 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MidtransBinDetails : NSObject <NSCoding, NSCopying>

@property (nonatomic) NSString *registrationRequired;
@property (nonatomic) NSString *countryName;
@property (nonatomic) NSString *countryCode;
@property (nonatomic) NSString *channel;
@property (nonatomic) NSString *brand;
@property (nonatomic) NSString *binType;
@property (nonatomic) NSString *binClass;
@property (nonatomic) NSString *bin;
@property (nonatomic) NSString *bankCode;
@property (nonatomic) NSString *bank;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END
