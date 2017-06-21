//
//  VTPaymentListModel.h
//
//  Created by Arie  on 6/17/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidtransPaymentListModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *localPaymentIdentifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic,strong) NSString *status;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *internalBaseClassDescription;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
