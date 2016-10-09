//
//  PaymentRequestPaymentOptions.h
//
//  Created by Arie  on 7/19/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MidtransPaymentRequestPaymentOptions : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL saveCard;
@property (nonatomic, assign) BOOL creditCard3dSecure;
@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSArray *binpromo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
