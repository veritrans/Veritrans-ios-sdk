//
//  MIDPaymentDetail.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 14/02/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MidtransSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDPaymentDetail : NSObject

@property (nonatomic, strong) NSString *paymentIdentifier;
@property (nonatomic, strong) NSString *paymentID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *paymentDescription;

@property (nonatomic) MIDPaymentMethod method;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;


@end

NS_ASSUME_NONNULL_END
